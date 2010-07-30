class Work_file
  text=''
  line_total = 0
  lines = 0
  @@r1 = Regexp.new('\.$')
  @@r2 = Regexp.new('^[1-9]?[0-9]\.$')
  
  def open_to_str(file)
    text=''
    File.open(file).each do |line|
      num_letras = line.length
      if num_letras > 2 && !@@r2.match(line) && @@r1.match(line)
       puts line 
       text << line
      end
    end
    puts text
  end    
end
  

texto1 = Work_file.new
texto1.open_to_str('teste.txt')
