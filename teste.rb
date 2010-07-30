text = %q{Los Angeles has some of the nicest weather in the country.}
stopwords = %w{the a by a for of are with just buy and to the my in I has some}

words = text.scan(/\w+/)
keywords =  words.select {|word| !stopwords.include?(word)}
puts keywords.join(' ')