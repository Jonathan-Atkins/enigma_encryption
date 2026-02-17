require './lib/enigma'
require 'date'


RSpec.describe Enigma do
  before(:each) do
    @enigma = Enigma.new
    @default_encryption = @enigma.encrypt("hello world", "02715", "040895")
  end


  it 'exists as an Enigma instance' do
    expect(@enigma).to be_an(Enigma)
  end


  it 'can encrypt a message with key and date' do
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
    expect(key.length).to eq(5)
    expect(key).to match(/^\d{5}$/)
  end


  it 'has a character set including space' do
    result = ("a".."z").to_a << " "
    expect(@enigma.alphabet).to eq(result)
  end


  it 'can encrypt a message using encrypt_message' do
    expect(@enigma.encrypt_message("hello world", "02715", "040895")).to eq("keder ohulw")
  end


  it 'can create the shift counts' do
    date_offset = ["1", "0", "2", "5"]
    key_placements = {A: 2, B: 27, C: 71, D: 15}
    result = {A: 3, B: 27, C: 73, D: 20}
    expect(@enigma.shift_counts(date_offset, key_placements)).to eq(result)
  end


  it 'can shift characters' do
    shifts = {A: 3, B: 27, C: 73, D: 20}
    message = ["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"]
    expect(@enigma.shift_characters(shifts, message)).to eq("keder ohulw")
  end


  it 'can run a case_when' do
    char = "h"
    shifts = {A: 3, B: 27, C: 73, D: 20}
    index = 0
    @enigma.shift_characters(shifts, ["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"])
    expect(@enigma.run_case_when(char, shifts, index)).to eq(@enigma.encrypted_message)
  end


  it 'can add shifts together' do
    @enigma.shift_characters({A: 3, B: 27, C: 73, D: 20}, ["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"])
    expect(@enigma.add_shifted_char(7, 3)).to eq(@enigma.encrypted_message)
  end


  it 'can setup key placements' do
    result = {A: 2, B: 27, C: 71, D: 15}
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
    @enigma.encrypt("hello world end", "08304", "291018")
    message = "vjqtbeaweqihssi"
    date = "291018"
    expect(@enigma.crack(message, date)).to eq(
      {
        decryption: "hello world end",
        date: "291018",
        key: "08304"
      }
    )
  end


  it 'can crack a message with today\'s date' do
    message = "vjqtbeaweqihssi"
    result = @enigma.crack(message)
    expect(result).to eq(
      {
        decryption: result[:decryption],
        date: Date.today.strftime("%d%m%y"),
        key: result[:key]
      }
    )
  end

  # Additional coverage for decrypt_message, unshift_characters, decrypt_run_case_when, subtract_shifted_char
  it 'can decrypt a message using decrypt_message' do
    encrypted = @enigma.encrypt("hello world", "02715", "040895")
    expect(@enigma.decrypt_message(encrypted[:encryption], "02715", "040895")).to eq("hello world")
  end

  it 'can unshift characters' do
    shifts = {A: 3, B: 27, C: 73, D: 20}
    message = ["k", "e", "d", "e", "r", " ", "o", "h", "u", "l", "w"]
    expect(@enigma.unshift_characters(shifts, message)).to eq("hello world")
  end

  it 'can run decrypt_run_case_when' do
    char = "k"
    shifts = {A: 3, B: 27, C: 73, D: 20}
    index = 0
    @enigma.unshift_characters(shifts, ["k", "e", "d", "e", "r", " ", "o", "h", "u", "l", "w"])
    expect(@enigma.decrypt_run_case_when(char, shifts, index)).to eq(@enigma.encrypted_message)
  end

  it 'can subtract shifted char' do
    @enigma.unshift_characters({A: 3, B: 27, C: 73, D: 20}, ["k", "e", "d", "e", "r", " ", "o", "h", "u", "l", "w"])
    expect(@enigma.subtract_shifted_char(10, 3)).to eq(@enigma.encrypted_message)
  end

  it 'squared returns the square of the date' do
    expect(@enigma.squared("040895")).to eq(1672401025)
  end

  it 'format_message downcases and splits message' do
    expect(@enigma.format_message("HELLO WORLD")).to eq(["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"])
  end

  it 'random_key always returns 5 digits' do
    10.times do
      expect(@enigma.random_key.length).to eq(5)
      expect(@enigma.random_key).to match(/^\d{5}$/)
    end
  end

  it 'alphabet always includes space' do
    expect(@enigma.alphabet.last).to eq(' ')
    expect(@enigma.alphabet.size).to eq(27)
  end

end