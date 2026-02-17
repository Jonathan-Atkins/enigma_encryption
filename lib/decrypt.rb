require_relative 'enigma'
require './modules/file_io'

message = FileIo.print_message 
content = FileIo.write_and_read_message(ARGV[0], message)
result  = FileIo.enigma_instance.decrypt(content)
output  = FileIo.write_output(ARGV[1],result[:decryption])

FileIo.show_status(output,ARGV[2],ARGV[3])