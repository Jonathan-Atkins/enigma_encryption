require_relative 'enigma'
require './modules/file_io'

# print "Provide message to encrypt:\n"
# message = $stdin.gets.chomp
message = FileIo.print_message 


# input  = ARGV[0]
output = ARGV[1]

# File.write(input,message)
content = FileIo.write_and_read_message(ARGV[0], message)

result = FileIo.enigma_instance.encrypt(content)


key  = result[:key]
date = result[:date]
encrypted_message = result[:encryption]

File.write(output,encrypted_message)


print "Created #{output} with the key #{key} and date #{date}"
