require 'date'

class Enigma
  CHAR_SET = (('a'..'z').to_a << ' ').freeze
  SHIFT_KEYS = %i[a b c d].freeze

  def encrypt(message = '', key = nil, date = nil)
    key_str = normalize_key(key)
    date_str = normalize_date(date)
    shifts = build_shifts(key_str, date_str)

    {
      encryption: shift_message(message.to_s, shifts, :encrypt),
      key: key_str,
      date: date_str
    }
  end

  def decrypt(ciphertext, key, date = nil)
    key_str = normalize_key(key, allow_random: false)
    date_str = normalize_date(date)
    shifts = build_shifts(key_str, date_str)

    {
      decryption: shift_message(ciphertext.to_s, shifts, :decrypt),
      key: key_str,
      date: date_str
    }
  end

  def crack(ciphertext, date = nil, known_suffix = ' end')
    date_str = normalize_date(date)
    key_str = find_key(ciphertext, date_str, known_suffix)
    raise ArgumentError, 'Unable to crack message with given date' unless key_str

    decrypt(ciphertext, key_str, date_str)
  end

  def encrypt_file(input_path, output_path, key = nil, date = nil)
    content = File.read(input_path)
    result = encrypt(content, key, date)
    File.write(output_path, result[:encryption])
    result
  end

  def decrypt_file(input_path, output_path, key, date = nil)
    content = File.read(input_path)
    result = decrypt(content, key, date)
    File.write(output_path, result[:decryption])
    result
  end

  private

  def normalize_key(key, allow_random: true)
    return random_key if key.nil? && allow_random

    key_str = key.to_s
    unless key_str.match?(/\A\d{5}\z/)
      raise ArgumentError, 'Key must be a 5-digit string'
    end
    key_str
  end

  def normalize_date(date)
    return today_string if date.nil?

    date_str = date.to_s
    unless date_str.match?(/\A\d{4,6}\z/)
      raise ArgumentError, 'Date must be a numeric string in DDMMYY format'
    end
    date_str
  end

  def random_key
    format('%05d', rand(0..99_999))
  end

  def today_string
    Date.today.strftime('%d%m%y')
  end

  def build_shifts(key_str, date_str)
    keys = split_keys(key_str)
    offsets = offset_from(date_str)

    keys.each_with_object({}) do |(name, value), hash|
      hash[name] = value + offsets[name]
    end
  end

  def split_keys(key_str)
    SHIFT_KEYS.each_with_index.to_h do |name, index|
      [name, key_str[index, 2].to_i]
    end
  end

  def offset_from(date_str)
    squared = date_str.to_i**2
    last_four = squared.to_s[-4..].rjust(4, '0')

    SHIFT_KEYS.each_with_index.to_h do |name, index|
      [name, last_four[index].to_i]
    end
  end

  def shift_message(message, shifts, direction)
    shift_index = 0

    message.chars.map do |char|
      if transformable?(char)
        shifted = shift_char(char, shifts[SHIFT_KEYS[shift_index % SHIFT_KEYS.length]], direction)
        shift_index += 1
        shifted
      else
        char
      end
    end.join
  end

  def shift_char(char, shift_value, direction)
    return char unless transformable?(char)

    base_char = char.downcase
    amount = direction == :decrypt ? -shift_value : shift_value
    shifted_char = CHAR_SET[(CHAR_SET.index(base_char) + amount) % CHAR_SET.length]

    char.match?(/[A-Z]/) ? shifted_char.upcase : shifted_char
  end

  def transformable?(char)
    CHAR_SET.include?(char.downcase)
  end

  def find_key(ciphertext, date_str, known_suffix)
    (0..99_999).lazy.map { |number| format('%05d', number) }.find do |candidate|
      decrypt(ciphertext, candidate, date_str)[:decryption].end_with?(known_suffix)
    end
  end
end
