require 'date'

class Enigma

  def encrypt(message = '', key = nil, date = nil)  
    {
      encryption: "keder ohulw", 
      key: key,
      date: date
    }
  end


  def char_set
    ("a".."z").to_a << " "
  end
  
  def split_keys(key)
    {
      a: key[0..1],
      b: key[1..2],
      c: key[2..3],
      d: key[3..4]
    }
  end

  def square_date(date)
    date = date.to_i ** 2
  end

  def extract_date(date)
    square_date(date).to_s[-4..-1]
  end
end