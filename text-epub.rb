R1 = Regexp.new('\.$')
R2 = Regexp.new('^Capitolo [1-9]?[0-9]\:$') 

class Work_file    
  @@text=''
  @@text_tem=''  
  @@long_line = 0
  @@short_line = 1200
  @@short_line_dot = 1220
  @@long_line_dot = 0
  
  
  def statistic     #checks the longest and the shortest line with and without dot. And with this information guess what is a paragraph
    num_char = 0
    num_lines = 0 
    @@text.each_line do |line|
      size = line.length
      if R1.match(line)
        if size > @@long_line_dot
          @@long_line_dot = size
        end
        if size < @@short_line_dot
          @@short_line_dot = size
        end
      else 
        if !R1.match(line) 
          if size > @@long_line
            @@long_line = size 
          end
          if size < @@short_line
            @@short_line = size
          end
        end
      end
    end
    puts "#{@@long_line_dot} longest line with dot"
    puts "#{@@short_line_dot} shortest line with dot"
    puts "#{@@long_line} longest line "
    puts "#{@@short_line} short line"   
  end  
  
  def open_to_str(file) #open the file and puts the line exept the blank in the text string
    File.open(file).each do |line|           
      num_letras = line.length
      if num_letras > 3 || R2.match(line)
        @@text << line
      end
    end
  end    
  
  def to_html  #Uses the string @text and puts the tag H2 for the chapters and normal tags for paragraphs.
    m = 0
    size = 0
    num_line = 0
    @@text.each_line do |line|      
      size = line.length
      if size < @@short_line && R2.match(line)
        puts "File #{num_line} created" 
        write_file("temp/temp#{num_line}.html")
        num_line = num_line + 1
        @@text_tem = ''
        @@text_tem << "<h2>"
        @@text_tem << line
        @@text_tem << "</h2\n>"
      else
        if m == 0
           @@text_tem << "<p>"
           m = 1
        end              
        if size < @@long_line && R1.match(line)
          @@text_tem << line
          @@text_tem << "</p>\n" 
          m = 0
        else
          @@text_tem << line
          m = 1
        end
      end
    end
  end

  def write_file(file)    #just write the files
    if File.exist?(file)
      file = File.open(file,"r+")
      file.write @@text_tem
      file.close
    else
      file = File.new(file,"a+")
      file.write @@text_tem
      file.close
    end
  end
   
   # From this part on the methods are to create the epub. I tought about create a class for that but 
   #decided to make it work and create the class later.
   # for now creates an basic structure(proof of concept) and now I will make it use the files I create on the methods above to create
   #the epub   

  def create_file(file_created)
    file = File.new(file_created,"a+")   
    file.close
  end
   
  def create_mimetype
    File.open("epub/mimetype","w+").each do |line|
      line.gsub(/\r\n?/, "")
    end

    
  end
                                 
  def create_container     
    container = ''
    container << "<?xml version=\"1.0\"?>"
   	container << "<container version=\"1.0\" xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\">\n"
   	container	<< "<rootfiles> <rootfile full-path=\"OEBPS/content.opf\" media-type=\"application/oebps-package+xml\" /> </rootfiles>\n"
   	container << "</container>\n"  
    if Dir.exist?("epub/META-INF")
      file = File.open("epub/META-INF/container.xml","w")
      file.write container
      file.close      
    else      
      Dir.mkdir("epub/META-INF","w")                 # Create a directory epub/META-INF   
      file = File.open("epub/META-INF/container.xml","w")    
      file.write container      
      file.close
      #$create_file("epub/META-INF/container.xml")
    end
  end
  
  def create_OEPBS
    if Dir.exist?("epub/OEBPS")
      create_opf
    else
      Dir.mkdir("epub/OEBPS")
      create_opf
    end    
  end
  
  def create_ncx
    content = ''
    create_header_ncx(content) 
    create_metadata_ncx(content)
    create_navMap(content)
    if !Dir.exist?("epub/OEBPS")
      Dir.mkdir("epub/OEBPS")
    end
    f = File.new("epub/OEBPS/toc.ncx","w+")
    f.write content
    f.close           
  end
                         
  def create_header_ncx(content)
    content << "<?xml version='1.0' encoding='utf-8'?> \n "
    content << "<!DOCTYPE ncx PUBLIC \"-//NISO//DTD ncx 2005-1//EN\"  \"http://www.daisy.org/z3986/2005/ncx-2005-1.dtd\">\n"
    content << "<ncx xmlns=\"http://www.daisy.org/z3986/2005/ncx/\" version=\"2005-1\">\n"    
  end 
  
  def create_metadata_ncx(content)
    content << "  <head>"
    content << "    <meta name=\"dtb:uid\" content=\"urn:uuid:0cc33cbd-94e2-49c1-909a-72ae16bc2658\"/>\n"
    content << "    <meta name=\"dtb:depth\" content=\"1\"/>\n"
    content << "    <meta name=\"dtb:totalPageCount\" content=\"0\"/>\n"
    content << "    <meta name=\"dtb:maxPageNumber\" content=\"0\"/>\n"
    content << "  </head>\n" 
    content << "  <docTitle>\n"
    content << "     <text>Hello World: My First EPUB</text> \n"
    content << "  </docTitle>\n"   
  end                  
  
  def create_navMap(content)
    content << "  <navMap> \n"
    content << "    <navPoint id=\"navpoint-1\" playOrder=\"1\">\n"
    content << "      <navLabel>\n"
    content << "        <text>Book cover</text>\n"
    content << "      </navLabel>\n"
    content << "      <content src=\"title.html\"/>\n"
    content << "    </navPoint>\n"
    content << "    <navPoint id=\"navpoint-2\" playOrder=\"2\">\n"
    content << "      <navLabel>\n"
    content << "        <text>Contents</text>\n"
    content << "      </navLabel>\n"
    content << "      <content src=\"content.html\"/>"
    content << "    </navPoint>\n"
    content << "  </navMap>\n"
    content << "</ncx>\n"
  end
  
  def create_opf
    content = ''
    create_metadata_opf(content)
    create_manifest_opf(content)
    create_spine_opf(content)  	
    file = File.new("epub/OEBPS/content.opf","w") 
    file.write content
    file.close
  end
  
  def create_spine_opf(content)
    content << "<spine toc=\"ncx\">\n"
  	content << "<itemref idref=\"cover\" linear=\"no\"/>\n"
  	content << " <itemref idref=\"content\"/> </spine>\n"
  	content << "<guide>" 
  	content << "<reference href=\"title.html\" type=\"cover\" title=\"Cover\"/>\n"
  	content << "</guide>\n" 
  	content << "</package>\n"
	end
    
  
  def create_metadata_opf(content)
    content << "<?xml version='1.0' encoding='utf-8'?>\n " 
  	content << "<package xmlns=\"http://www.idpf.org/2007/opf\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" unique-identifier=\"bookid\" version=\"2.0\">" 
    content << "<metadata>\n"
    content << "<dc:title>Hello World: My First EPUB</dc:title>\n "
  	content << "<dc:creator>My Name</dc:creator> <dc:identifier id=\"bookid\">urn:uuid:0cc33cbd-94e2-49c1-909a-72ae16bc2658</dc:identifier>\ "
  	content << "<dc:language>en-US</dc:language> <meta name=\"cover\" content=\"cover-image\" /> \n"
  	content << "</metadata> \n"
  end 
  
  def create_manifest_opf(content) 
    content << "<manifest>\n"
  	content << "<item id=\"ncx\" href=\"toc.ncx\" media-type=\"application/x-dtbncx+xml\"/>\n "
  	content << "<item id=\"cover\" href=\"title.html\" media-type=\"application/xhtml+xml\"/>\n "
  	content << "<item id=\"content\" href=\"content.html\" media-type=\"application/xhtml+xml\"/>\n" 
  	content << "<item id=\"cover-image\" href=\"images/cover.png\" media-type=\"image/png\"/> \n"
  	content << "<item id=\"css\" href=\"stylesheet.css\" media-type=\"text/css\"/>\n"
  	content << "</manifest> \n"
  end
  
  def create_title_page
    content = ''
    content << "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
    content << "  <head>\n"
    content << "    <title>Hello World: My First EPUB</title>\n"
    content << "    <link type=\"text/css\" rel=\"stylesheet\" href=\"stylesheet.css\" />\n"
    content << "  </head>\n"
    content << "  <body>\n"
    content << "    <h1>Hello World: My First EPUB</h1>\n"
    content << "    <div><img src=\"images/cover.png\" alt=\"Title page\"/></div>\n"
    content << "  </body>\n"
    content << "</html>\n"
    f = File.new("epub/OEBPS/title.html","w+")
    f.write content
    f.close
  end
  
  def create_book_css
    content = ''
    content << "body {\n"
    content << "  font-family: sans-serif;\n"     
    content << "}\n"
    content << "h1,h2,h3,h4 {\n"
    content << "  font-family: serif;\n"     
    content << "  color: blue;\n"
    content << "}\n"
    f = File.new("epub/OEBPS/stylesheet.css","w+")
    f.write content
    f.close    
  end
   
  def create_images_dic
    if !Dir.exist?("epub/OEBPS/images")
      Dir.mkdir('epub/OEBPS/images')
    end
  end
  
  def create_zip
    IO.popen("zip -0Xq my-book.epub epub/mimetype")
    IO.popen("zip -Xr9Dq my-book.epub epub/*") 
  
  end
     
  
  def create_epub
    create_mimetype
    create_container
    create_OEPBS 
    create_ncx
    create_title_page
    create_book_css
    create_images_dic
    create_zip
  end
 
end


texto1 = Work_file.new
texto1.open_to_str('Harry.txt') 
texto1.statistic
texto1.to_html
texto1.create_epub