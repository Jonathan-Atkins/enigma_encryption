require 'date'

class Enigma
  attr_reader :new_message, :message, :date
  
  def initialize(message, key = nil, date = nil)
    @message     = message.downcase.split("")
    @date        = date || Date.today.strftime("%d%m%y")
    @key         = key || generate_key
    @char_set    = ("a".."z").to_a << " "
    @shift_keys  = [:A, :B, :C, :D]
  end

  def encrypt
    {
      encryption: message_encrypted(date_shifts(@date), key_shifts(@key)),
      key: @key,
      date: @date
    }
  end

  def date_shifts(date)
    squared     = squares_date(date)
    last_four   = last_four(squared)
    {
      A: last_four[0],
      B: last_four[1],
      C: last_four[2],
      D: last_four[3]
    }
  end

  def squares_date(date)
    date.to_s.rjust(6, '0').to_i ** 2
  end

  def last_four(squared)
    squared.to_s[-4..-1]
  end

  def generate_key
    key = rand(0..99999).to_s.rjust(5, '0')
  end
  
  def key_shifts(key)
    {
      A: key[0..1],
      B: key[1..2],
      C: key[2..3],
      D: key[3..4]
    }
  end

  def sum_shift_pair(date_value,key_value)
    date_value.to_i + key_value.to_i
  end

  def message_encrypted(date_shifts, key_shifts)
    shifts = final_shifts(date_shifts, key_shifts)
    apply_shifts(shifts)
  end

  def apply_shifts(final_shifts)
    new_message = []
    @message.each_with_index do |letter, index|
      new_message << shift_letter(letter, index, final_shifts)
    end
    new_message.join
  end

  def shift_letter(letter, index, final_shifts)
    if @char_set.include?(letter)
      shift_key    = @shift_keys[index % 4]
      shift_amount = final_shifts[shift_key]
      current_pos  = @char_set.index(letter)
      new_pos      = (current_pos + shift_amount) % @char_set.length
      @char_set[new_pos]
    else
      letter
    end
  end

  def final_shifts(date_shifts, key_shifts)
    date_shifts.each_with_object({}) do |(letter,value), result|
      result[letter] = sum_shift_pair(value,key_shifts[letter])  
    end
  end
end
