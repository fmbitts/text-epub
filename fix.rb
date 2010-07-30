m=0
text=''
text_temp='' 
temp = ''
r1 = Regexp.new('\.$')
r2 = Regexp.new('^[1-9]?[0-9]\.$')
File.open('the.txt').each  do |line| 
   num_letras = line.length 

   if m == 0
     text << "<p>\n"
     m = 1
   end
   if num_letras > 2 && !r2.match(line)    
     # if num_letras <64 && valor_ponto ==true
     if num_letras <69 && /\.$/.match(line)
       text << line
       text << "</p>\n"
       m=0
     else
       text << line
     end
   else 
     if r2.match(line)
       temp << r2.match(line).to_s()
       text_temp << "<h2>" + temp + "</h2>\n"
       text << "<h2>" + temp + "</h2>\n"
       temp = ''
     end
         
   end
end

  
class Work_file
  def initialize(arquivo)
    @arquivo = arquivo
  end
  
  
  def open_to_str
    File.open(@arquivo)
      @arquivo.each do |line|
        if m == 0
           text << "<p>\n"
           m = 1
         end
         if num_letras > 2 && !r2.match(line)    
           # if num_letras <64 && valor_ponto ==true
           if num_letras <69 && /\.$/.match(line)
             text << line
             text << "</p>\n"
             m=0
           else
             text << line
           end
         else 
           if r2.match(line)
             temp << r2.match(line).to_s()
             text_temp << "<h2>" + temp + "</h2>\n"
             text << "<h2>" + temp + "</h2>\n"
             temp = ''
           end
         end
      end  
  end
end
  

texto1 = Work_file.new("texto.txt")
texto1.open_to_str



puts text 
puts text_temp
f = File.open("the.html", "r+")
f.write text
f.close


     
