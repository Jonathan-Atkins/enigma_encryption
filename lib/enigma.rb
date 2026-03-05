class Enigma
  def encrypt(message,key=nil,date=nil)
    {
      encryption: tokenize(message),
      key: key,
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
    date.to_s.rjust(6, '0')
    date = date.to_i ** 2
  end

  def offset(date)
    "%4d" % (date % 10000)
  end
end