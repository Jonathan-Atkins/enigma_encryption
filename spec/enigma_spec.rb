require './lib/enigma'
require 'date'

RSpec.describe 'Enigma'do
  before(:each) do
    @enigma             = Enigma.new
    @default_encryption = @enigma.encrypt("hello world", "02715","040895")
  end

  it 'exists' do
    expect(@enigma).to be_an(Enigma)
  end

  it 'can encrypt a message' do
    expect(@default_encryption).to eq(
      {
        encryption: "keder ohulw",
        key: "02715",
        date: "040895"
      }
    )
  end

  it 'can generate random keys' do
    key = @enigma.random_key
    expect(key).to be_a(String)
    expect(key.length).to eq(6)
    expect(key).to match(/^\d{6}$/)
  end

  it 'has a character set' do
    result = ("a".."z").to_a << " "
    expect(@enigma.alphabet).to eq(result)
  end

  it 'can encrypt a message' do
    expect(@enigma.encrypt_message("hello world","02715","040895")).to eq("keder ohulw")
  end

  it 'can create the shift counts' do
    date_offset     = ["1", "0", "2", "5"]
    key_placements  = {:A=>2, :B=>27, :C=>71, :D=>15}
    result          = {:A=>3, :B=>27, :C=>73, :D=>20}
    
    expect(@enigma.shift_counts(date_offset, key_placements)).to eq(result)
  end

  it 'can shift characters' do
    shifts = {:A=>3, :B=>27, :C=>73, :D=>20}
    message     = ["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"]

    expect(@enigma.shift_characters(shifts,message)).to eq("keder ohulw")
  end

  it 'can run a case_when' do
    char   = "h"
    shifts = {:A=>3, :B=>27, :C=>73, :D=>20}
    index  = 0
    result = "keder ohulwk"

    expect(@enigma.run_case_when(char,shifts,index)).to eq(result)
  end

  it 'can add shifts together' do 
     expect(@enigma.add_shifted_char(7,3)).to eq("keder ohulwk")
  end

  it 'can setup key placements' do
    result = {:A=>2, :B=>27, :C=>71, :D=>15}

    expect(@enigma.key_placements("02715")).to eq(result)
  end

  it 'can offset the date' do
    date = "040895"
    
    expect(@enigma.date_offset(date)).to eq(["1", "0", "2", "5"])
  end

  it 'can format a message' do
    message = "hello world"

    expect(@enigma.format_message(message)).to eq(["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"])
  end

  it 'can crack a message with a date' do
    message = "vjqtbeaweqihssi"
    key     = "08304"
    date    = "291018"

    expect(@enigma.crack(message,date,key)).to eq(
      {
        decryption: "hello world end",
        date: "291018",
        key: "08304"
      }
    )
  end

  it 'can crack a message with todays date' do
    message = "vjqtbeaweqihssi"
    result  = @enigma.crack(message)

    expect(result).to eq(
      {
        decryption: result[:decryption],
        date: Date.today.strftime("%d%m%y"),
        key: result[:key]
      }
    )
  end
end