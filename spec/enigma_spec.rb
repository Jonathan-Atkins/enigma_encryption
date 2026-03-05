require './lib/enigma'

RSpec.describe 'Enigma'do
  before(:each) do
    @enigma = Enigma.new
  end

  it 'exists' do

  expect(@enigma).to be_an(Object)
  end

  xit 'can encrypt a message with a key and date' do 
    expect(@enigma.encrypt("hello world", "02715","040895")).to eq(
      {
        encryption: "keder ohulw",
        key: "02715",
        date: "040895"
      })
  end

  it 'can downcase and split messages' do
    expect(@enigma.tokenize("HELLO WORLD")).to eq(["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"])
  end

  it 'can set characters' do 
    expect(@enigma.char_set).to eq(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "])
  end

  it 'squares the dates' do
    date = "040895"
    expect(@enigma.squares_date(date)).to eq(1672401025)
  end

  it 'can get last four digits of a number' do
    num = 1672401025

    expect(@enigma.offset(num)).to eq('1025')
  end

  it 'can generate a key' do
    expect(@enigma.generate_key).to match(/^\d{5}$/)
  end

  it 'can set key_shift values' do
    key = '02715'

    expect(@enigma.key_shifts(key)).to eq(
      {
        A: '02',
        B: '27',
        C: '71',
        D: '15'
      }
    )
  end
end