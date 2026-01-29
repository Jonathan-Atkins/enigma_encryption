require_relative 'enigma'


print "Provide message to encrypt:\n"
message = $stdin.gets.chomp

input  = ARGV[0]
output = ARGV[1]

File.write(input,message)

content = File.read(input)

enigma = Enigma.new

result = enigma.encrypt(content)

key  = result[:key]
date = result[:date]
encrypted_message = result[:encryption]

File.write(output,encrypted_message)


print "Created #{output} with the key #{key} and date #{date}"
