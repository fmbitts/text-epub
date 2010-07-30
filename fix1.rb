num_line=0
n=1
text=''
text_temp=''
File.open('teste.txt').each  do |line| 
  a = line.length 
  text_temp << '<p>'  
  if a > 70    
    text_temp << line
  else 
    text_temp << line
    text_temp << '</p>'
  end
  text << text_temp
  text_temp = ''
end


puts text
f = File.open("file1.txt", "r+")
f.write text
f.close

