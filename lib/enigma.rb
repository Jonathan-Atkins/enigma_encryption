require 'date'

class Enigma
  attr_reader :encryption,
              :key,
              :date
  def initialize(encryption = '',key = '',date = '')
    @encryption = encryption.downcase
    @key     = key
    @date    = date
  end

  def encrypt(encryption,key,date)
    {
    encryption: rewrite(@encryption),
    key: @key,
    date: @date
   }
  end

  def rewrite(encryption)
    
  end
  
end