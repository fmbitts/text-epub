R1 = Regexp.new('\.$')
R2 = Regexp.new('^Capitolo [1-9]?[0-9]\:$')

class Work_file    
  @@text=''
  @@text_tem=''  
  @@long_line = 0
  @@short_line = 1200
  @@short_line_dot = 1220
  @@long_line_dot = 0
  
  
  def statistic     #checks the longest and the shortest line with and without dot
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
  
  def to_html
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

  def write_file(file)    
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
      

  def create_file(file_created)
    file = File.new(file_created,"a+")   
    file.close
  end
   
  def create_mimetype
    # after just add the check if the directory exist
    create_file('epub/mimetype')
  end
                                 
  def create_container     
    container = ''
    container << %s{<?xml version="1.0"?>}
   	container << %s{<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">}
   	container	<< %s{<rootfiles> <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml" /> </rootfiles>}
   	container << %s{</container>}  
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
  
  def create_OPBS
    if Dir.exist?('epub/OPBS')
      create_content
    else
      Dir.mkdir('epub/OPBS')
      create_content
    end    
  end
  
  def create_content
    
  end
  
  def create_epub
    create_mimetype
    create_container
  end
 
end


texto1 = Work_file.new
texto1.open_to_str('Harry.txt') 
texto1.statistic
texto1.to_html
texto1.create_epub