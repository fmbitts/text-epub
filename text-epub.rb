R1 = Regexp.new('\.$')
R2 = Regexp.new('^Capitolo [1-9]?[0-9]\:$')          

class Work_file    
  @@text=''
  @@text_tem= ''
  @@long_line = 0
  @@short_line = 1200
  @@short_line_dot = 1220
  @@long_line_dot = 0
  @@name_book = ''
  @@author_book = ''
  @@isbn13 = '' #future thing to get the number and acess via http and get all de information from isbn servers
  @@num_line = 0
  def random
    rand(10000000)
  end
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
  
  def get_book_information
        puts "Please insert the name of the book or document"
    #    @@name_book = gets
        @@name_book = "Harry Potter e la Pietra Filosofale"
        puts "Please insert the author of the book or document"
    #    @@author_book = gets
        @@author_book = "J.K Rowling"
        @@identifier_id = random  
  end
  
  def to_html
    get_book_information
    m = 0
    size = 0
    @@text_tem << "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n"
    @@text_tem << "<head>\n "
    @@text_tem << "  <title>Hello World: My First EPUB</title>\n "
    @@text_tem << "  <link type=\"text/css\" rel=\"stylesheet\" media=\"all\" href=\"stylesheet.css\" />\n"
    @@text_tem << "</head>\n"
    @@text_tem << "<body>\n"
    @@text.each_line do |line|      
      size == line.length
      if size < @@short_line && R2.match(line)
        puts @@num_line
        @@text_tem << "</body>\n"
        @@text_tem << "</html>\n"
        write_file("temp/temp#{@@num_line}.html")
        write_file("epub/OEBPS/files#{@@num_line}.html")        
        @@num_line = @@num_line + 1
        @@text_tem = ''
        @@text_tem << "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n"
        @@text_tem << "<head>\n "
        @@text_tem << "  <title>Hello World: My First EPUB</title>\n "
        @@text_tem << "  <link type=\"text/css\" rel=\"stylesheet\" media=\"all\" href=\"stylesheet.css\" />\n"
        @@text_tem << "</head>\n"
        @@text_tem << "<body>\n"
        @@text_tem << "<h2>"
        @@text_tem << line
        @@text_tem << "</h2>\n"
      else
        if m == 0
           @@text_tem << "<p>"
           m =1
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
    puts @@num_line
    write_file("temp/temp#{@@num_line}.html")
    write_file("epub/OEBPS/files#{@@num_line}.html")
  end
  
 

  def create_content
    
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
  
  # Those following methodos are to create the file toc.ncx
  
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
    content << "     <text>#{@@author_book}</text> \n"
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
    content << "      <content src=\"files0.html\"/>"
    content << "    </navPoint>\n"
    content << "  </navMap>\n"
    1.upto(@@num_line) do |file_number|
      content << "    <navPoint id=\"navpoint-#{file_number + 2}\" playOrder=\"#{file_number + 2}\">\n"
      content << "      <navLabel>\n"
      content << "        <text>Chapter #{file_number}</text>\n"
      content << "      </navLabel>\n"
      content << "      <content src=\"files#{file_number}.html\"/>"
      content << "    </navPoint>\n"
      content << "  </navMap>\n" 
    end
    # content << "    <navPoint id=\"navpoint-3\" playOrder=\"3\">\n"
    # content << "      <navLabel>\n"
    # content << "        <text>Chapter 1</text>\n"
    # content << "      </navLabel>\n"
    # content << "      <content src=\"files1.html\"/>"
    # content << "    </navPoint>\n"
    # content << "  </navMap>\n"
    # content << "    <navPoint id=\"navpoint-4\" playOrder=\"4\">\n"
    # content << "      <navLabel>\n"
    # content << "        <text>Chapter 2</text>\n"
    # content << "      </navLabel>\n"
    # content << "      <content src=\"files2.html\"/>"
    # content << "    </navPoint>\n"
    # content << "  </navMap>\n"    
  end
  
  # Those following methodos are to creaate the file content.opf
  
  def create_opf
    content = ''
    create_metadata_opf(content)
    create_manifest_opf(content)
    create_spine_opf(content)  	
    file = File.new("epub/OEBPS/content.opf","w") 
    file.write content
    file.close
  end
       
  def create_metadata_opf(content)
    content << "<?xml version='1.0' encoding='utf-8'?>\n" 
  	content << "<package xmlns=\"http://www.idpf.org/2007/opf\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" unique-identifier=\"bookid\" version=\"2.0\">\n" 
    content << "  <metadata>\n"
    content << "    <dc:title>#{@@name_book}</dc:title>\n"
  	content << "    <dc:creator>#{@@author_book}</dc:creator>\n" 
  	content << "    <dc:identifier id=\"bookid\">#{@@identifier_id}</dc:identifier>\n"
  	content << "    <dc:language>en-US</dc:language> <meta name=\"cover\" content=\"cover-image\" />\n"
  	content << "  </metadata>\n"
  end 
  
  def create_manifest_opf(content) 
    content << "  <manifest>\n"
  	content << "    <item id=\"ncx\" href=\"toc.ncx\" media-type=\"application/x-dtbncx+xml\"/>\n"
  	content << "    <item id=\"cover\" href=\"title.html\" media-type=\"application/xhtml+xml\"/>\n"
   1.upto(@@num_line) do |file_number|
    content << "    <item id=\"chapter#{file_number}\" href=\"files#{file_number}.html\" media-type=\"application/xhtml+xml\"/>\n"
  end 
    # content << "    <item id=\"chapter1\" href=\"files1.html\" media-type=\"application/xhtml+xml\"/>\n" 
    # content << "    <item id=\"chapter2\" href=\"files2.html\" media-type=\"application/xhtml+xml\"/>\n" 
  	content << "    <item id=\"cover-image\" href=\"images/cover.png\" media-type=\"image/png\"/> \n"
  	content << "    <item id=\"css\" href=\"stylesheet.css\" media-type=\"text/css\"/>\n"
  	content << "  </manifest> \n"
  end

  def create_spine_opf(content) 
    content << "  <spine toc=\"ncx\">\n"
    content << "    <itemref idref=\"cover\" linear=\"no\"/>\n"
    content << "    <itemref idref=\"reference\"/>\n" 
    1.upto(@@num_line) do |file_number|
      content << "    <itemref idref=\"chapter#{file_number}\"/>\n"
    end     
    # content << "    <itemref idref=\"chapter1\"/>\n"     
    # content << "    <itemref idref=\"chapter2\"/>\n"     
    content << "  </spine>\n"
    content << "  <guide>\n" 
    content << "    <reference href=\"title.html\" type=\"cover\" title=\"Cover\"/>\n"
    content << "  </guide>\n" 
    content << "</package>\n"
  end  
  # The following method creates the title.html which is the title page for the epub.
  
  def create_title_page
    content = ''
    content << "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
    content << "  <head>\n"
    content << "    <title>#{@@name_book}</title>\n"
    content << "    <link type=\"text/css\" rel=\"stylesheet\" href=\"stylesheet.css\" />\n"
    content << "  </head>\n"
    content << "  <body>\n"
    content << "    <h1>#{@@name_book}</h1>\n"
    content << "    <div><img src=\"images/cover.png\" alt=\"Title page\"/></div>\n"
    content << "  </body>\n"
    content << "</html>\n"
    f = File.new("epub/OEBPS/title.html","w+")
    f.write content
    f.close
  end
   
  # The method create the css template for the epub.
  
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
  
  # the following method create de directory for the images and will cope images from a specific directory to the epub 
  def create_images_dic
    if !Dir.exist?("epub/OEBPS/images")
      Dir.mkdir('epub/OEBPS/images')
    end
  end
  
  # the following method creates the epub file.
  def create_zip
    IO.popen("zip -0Xq Harry.epub epub/mimetype")
    IO.popen("zip -Xr9Dq Harry.epub epub/*") 
  
  end
     
  # the following method agreagates all the anterior methods to create the files do the create_zip method.
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