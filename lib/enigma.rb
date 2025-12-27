require 'date'

class Enigma

  def encrypt(message = '', key = nil, date = nil)
    key_str   = key_check(key)
    date_str  = date_check(date)
    shifts    = shifts_for(key_str, date_str)
    encrypted = encrypt_message(message, shifts)
    {
      encryption: encrypted,
      key: key_str,
      date: date_str
    }
  end

  # Encrypts the message, shifting only valid chars, leaving others (including space) in place
  def encrypt_message(message, shifts)
    shift_keys  = [:a, :b, :c, :d]
    shift_index = 0
    result = message.chars.map do |char|
      if char_set.include?(char.downcase)
        shifted = shift_char(char, shifts[shift_keys[shift_index % 4]])
        shift_index += 1
        shifted
      else
        char
      end
    end
    result.join.downcase
  end

  # Shifts a single character by the given amount, preserving case
  def shift_char(char, shift)
    is_upper = char =~ /[A-Z]/
    base_char = char.downcase
    if char_set.include?(base_char)
      idx = char_set.index(base_char)
      shifted_idx = (idx + shift) % char_set.length
      shifted_char = char_set[shifted_idx]
      is_upper ? shifted_char.upcase : shifted_char
    else
      return char
    end
  end

  #!key checks
  def key_check(key)
    key.nil? ? self.randomize_key : key
  end 

  # .rjust(5, "0") pads the string with leading zeros if needed, ensuring it is always 5 characters long.
  def randomize_key
    rand(10000..99999).to_s.rjust(5, "0")
  end

  #*date checks

  def date_check(date)
    date.nil? ? self.create_date : date
  end

  def create_date
    extract_date(Date.today.strftime("%d%m%y"))
  end
 
  #!Shifts
  def shifts_for(key, date)
    keys    = split_keys(key)
    offsets = split_date(extract_date(date))
    create_shift(offsets, keys)
  end

  def split_keys(key)
    {
      a: key[0..1],
      b: key[1..2],
      c: key[2..3],
      d: key[3..4]
    }
  end

  def split_date(date)
    {
      a: date[0],
      b: date[1],
      c: date[2],
      d: date[3]
    }
  end

  def extract_date(date)
    square_date(date).to_s[-4..-1]
  end

  def square_date(date)
    date.to_i ** 2
  end

  def create_shift(dates,keys)
    keys.keys.each_with_object({}) do |k, hash|
      hash[k] = keys[k].to_i + dates[k].to_i
    end
  end

  # Returns true if all characters in the message are in the char_set

  def valid_message_chars?(message)
    message.chars.all? { |char|  char_set.include?(char) }
  end

  # Converts invalid message characters to a valid char (default: space)
  # Returns the allowed character set for mes sages
  def char_set
    ("a".."z").to_a << " "
  end
end



