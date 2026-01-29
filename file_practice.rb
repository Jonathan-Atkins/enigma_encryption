input  = ARGV[0]
output = ARGV[1]

phrase = File.read(input)

loud_phrase = phrase.upcase

File.write(output,loud_phrase)

# ruby <filename.rb> quiet_quotes.txt loud_quotes.txt
# ruby file_practice.rb quiet_quotes.txt loud_quotes.txt
