class Enigma
  attr_reader :new_message,
              :message
 
  

  def initialize
    @new_message = []
    @message     = message
  end

  def encrypt(message = nil,key=nil,date=nil)
    {
      encryption: tokenize(message),
      key: key.nil ? generate_key : key_offset(key),
      date: offsets(date)
    }
  end

  def tokenize(message)
    message.downcase.split('')
  end

  def char_set
    ("a".."z").to_a << " "
  end

  def squares_date(date)
    date = date.to_s.rjust(6, '0').to_i ** 2
  end

  def offset(date)
    "%4d" % (date % 10000)
  end

  def date_shifts

  def generate_key
    key = rand(0..99999).to_s.rjust(5, '0')
  end
  
  def key_shifts(key)
    key_shifts = {
      A:key[..1],
      B:key[1..2],
      C:key[2..3],
      D:key[3..4]
    }
  end
end