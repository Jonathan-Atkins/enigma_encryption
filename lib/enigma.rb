require 'date'



# Enigma class provides encryption, decryption, and cracking for messages using a simple cipher.
class Enigma
  attr_reader :encrypted_message, :crack_key

  def initialize
    @encrypted_message = ''
    @crack_key = nil
  end


  def encrypt(message, key = nil, date = nil)
    key  ||= random_key
    date ||= Date.today.strftime('%d%m%y')
    @crack_key = key
    {
      encryption: encrypt_message(message, key, date),
      key: key,
      date: date
    }
  end


  def decrypt(message, key = nil, date = nil)
    key  ||= random_key
    date ||= Date.today.strftime('%d%m%y')
    {
      decryption: decrypt_message(message, key, date),
      key: key,
      date: date
    }
  end


  def random_key
    rand(0...100_000).to_s.rjust(5, '0')
  end


  def encrypt_message(message, key, date)
    shifts = shift_counts(date_offset(date), key_placements(key))
    shift_characters(shifts, format_message(message))
  end

  def decrypt_message(message, key, date)
    shifts = shift_counts(date_offset(date), key_placements(key))
    unshift_characters(shifts, format_message(message))
  end


  def crack(message, date = nil)
    cracked_message = decrypt(message, @crack_key, date)
    {
      decryption: cracked_message[:decryption],
      date: cracked_message[:date],
      key: cracked_message[:key]
    }
  end


  def shift_counts(date_offset, key_placements)
    {
      A: key_placements[:A] + date_offset[0].to_i,
      B: key_placements[:B] + date_offset[1].to_i,
      C: key_placements[:C] + date_offset[2].to_i,
      D: key_placements[:D] + date_offset[3].to_i
    }
  end


  def shift_characters(shifts, message)
    @encrypted_message = ''
    message.each_with_index do |char, index|
      if alphabet.include?(char)
        if char == ' '
          @encrypted_message << char
        else
          run_case_when(char, shifts, index)
        end
      end
    end
    @encrypted_message
  end


  def unshift_characters(shifts, message)
    @encrypted_message = ''
    message.each_with_index do |char, index|
      if alphabet.include?(char)
        if char == ' '
          @encrypted_message << char
        else
          decrypt_run_case_when(char, shifts, index)
        end
      end
    end
    @encrypted_message
  end


  def alphabet
    ('a'..'z').to_a << ' '
  end


  def run_case_when(char, shifts, index)
    char_index = alphabet.index(char)
    case index % 4
    when 0
      add_shifted_char(char_index, shifts[:A])
    when 1
      add_shifted_char(char_index, shifts[:B])
    when 2
      add_shifted_char(char_index, shifts[:C])
    when 3
      add_shifted_char(char_index, shifts[:D])
    end
    @encrypted_message
  end


  def decrypt_run_case_when(char, shifts, index)
    char_index = alphabet.index(char)
    case index % 4
    when 0
      subtract_shifted_char(char_index, shifts[:A])
    when 1
      subtract_shifted_char(char_index, shifts[:B])
    when 2
      subtract_shifted_char(char_index, shifts[:C])
    when 3
      subtract_shifted_char(char_index, shifts[:D])
    end
    @encrypted_message
  end


  def add_shifted_char(char_index, shift_num)
    shift_count = (char_index + shift_num) % 27
    @encrypted_message << alphabet[shift_count]
    @encrypted_message
  end

  def subtract_shifted_char(char_index, shift_num)
    shift_count = (char_index - shift_num) % 27
    @encrypted_message << alphabet[shift_count]
    @encrypted_message
  end


  def key_placements(key)
    {
      A: key[0..1].to_i,
      B: key[1..2].to_i,
      C: key[2..3].to_i,
      D: key[3..4].to_i
    }
  end


  def date_offset(date)
    squared(date).to_s[-4..-1].split('')
  end


  def squared(date)
    date.to_i**2
  end


  def format_message(message)
    message.downcase.chars
  end

end



# Example usage (uncomment to run):
# enigma = Enigma.new
# encrypted = enigma.encrypt("hello world", "02715", "040895")
# decrypted = enigma.decrypt("keder ohulw", "02715", "040895")
# puts "Encrypted Message: #{encrypted}"
# puts "Decrypted Message: #{decrypted}"