class Work_file
  @@text=''
  @@text_tem=''
  @@r1 = Regexp.new('\.$')
  @@r2 = Regexp.new('^[1-9]?[0-9]\.$')
  @@long_line = 0
  @@short_line = 1200
  @@short_line_dot = 1220
  @@long_line_dot = 0
  
  
  def statistic     #checks the longest and the shortest line with and without dot
    size = 0
    num_char = 0
    num_lines = 0            
    
    @@text.each do |line|
      size = line.length
      if @@r1.match(line)
        if size > @@long_line_dot
          @@long_line_dot = size
        end
        if size < @@short_line_dot
          @@short_line_dot = size
        end
      else 
        if !@@r1.match(line) 
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
      if num_letras > 3 || @@r2.match(line)
        @@text << line
      end
    end
  end    
  
  def to_html
    m = 0
    size = 0
    num_line = 0
    @@text.each do |line|
      size == line.length
      if size < @@short_line && @@r2.match(line)
        puts num_line
        write_file("temp#{num_line}.html")
        num_line = num_line + 1
        @@text_tem = ''
        @@text_tem << "<h2>"
        @@text_tem << line
        @@text_tem << "</h2\n>"
      else
        if m == 0
           @@text_tem << "<p>"
           m =1
         end              
        if size < @@long_line && @@r1.match(line)
          @@text_tem << line
          @@text_tem << "</p>\n" 
          m = 0
        else
          @@text_tem << line
          m = 1
        end
      end
    end
    puts @@text_tem
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
      


end
  

texto1 = Work_file.new
texto1.open_to_str('teste.txt') 
texto1.statistic
texto1.to_html
