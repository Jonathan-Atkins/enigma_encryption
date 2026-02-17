
# FileIo module provides file input/output utilities for the Enigma project.
module FileIo
  def self.print_message
    print "Provide message to encrypt:\n"
    $stdin.gets.chomp
  end

  def self.write_and_read_message(input, message)
    File.write(input, message)
    File.read(input)
  end

  def self.enigma_instance
    Enigma.new
  end

  def self.write_output(output, message)
    File.write(output, message)
  end

  def self.show_status(output, key, date)
    print "Created #{output} with the key: #{key} and date: #{date}"
  end
end