require 'spec_helper'
require './lib/enigma'

RSpec.describe Enigma do

    it 'encrypts message with spaces and valid chars, leaving spaces in place' do
      expect(@enigma.encrypt("hello world", "02715", "040895")).to eq(
        {
          encryption: "keder ohulw",
          key: "02715",
          date: "040895"
        }
      )
    end

    it 'encrypts message with uppercase letters, leaving spaces in place' do
      expect(@enigma.encrypt("HELLO WORLD", "02715", "040895")).to eq(
        {
          encryption: "KEDER OHULW",
          key: "02715",
          date: "040895"
        }
      )
    end

    it 'encrypts message with invalid characters, leaving them in place' do
      expect(@enigma.encrypt("hello world!", "02715", "040895")).to eq(
        {
          encryption: "keder ohulw!",
          key: "02715",
          date: "040895"
        }
      )
    end
  before(:each) do
    @enigma = Enigma.new
    @date   = "040895"
  end

  it 'exists' do
    expect(@enigma).to be_an_instance_of(Enigma)
  end

  it 'returns encyrpted message' do
    expect(@enigma.encrypt("hello world", "02715", "040895")).to eq(
      {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
      }
    )
  end

  it 'can check if a key exists' do
    result = @enigma.encrypt("hello world", "02715", "040895")
    expect(@enigma.key_check(result[:key])).to eq("02715")
  end
  
  it 'can create random key' do
    key = @enigma.randomize_key
    expect(key).to be_a(String)
    expect(key.length).to eq(5)
    expect(key).to match(/\A\d{5}\z/)
  end

  it 'splits a 5-digit key into A, B, C, D keys' do
    key = "02715"
    result = @enigma.split_keys(key)
    expect(result).to eq({
      a: "02",
      b: "27",
      c: "71",
      d: "15"
    })
  end

  it 'can check if a date exists' do
    result = @enigma.encrypt("hello world", "02715", "040895")
    expect(@enigma.date_check(result[:date])).to eq("040895")
  end

  it 'can generate todays date' do
    date = @enigma.create_date
    expect(date).to be_a(String)
    expect(date.length).to eq(4)
    expect(date).to match(/\A\d{4}\z/)
  end

  it 'squares the date' do
    expect(@date).to eq("040895")
    expect(@enigma.square_date(@date)).to eq(1672401025)
  end

  it 'extracts the last four digits from the squared date' do
    result = @enigma.extract_date(@date)
    expect(result.length).to eq(4)
  end

  it 'splits the date into A,B,C,D keys' do
    date = @enigma.split_date("1234")
    
    expect(date[:a]).to eq("1")
    expect(date[:b]).to eq("2")
    expect(date[:c]).to eq("3")
    expect(date[:d]).to eq("4")
  end

  it 'creates the shifts' do
    result = @enigma.encrypt("hello world", "02715", "040895")
    shifts = @enigma.shifts_for(result[:key],result[:date])
    
    expect(shifts).to eq({
      a: 3,
      b: 27,
      c: 73,
      d: 20
    })
  end

  it 'returns true if all message characters are in the char_set' do
    # expect(@enigma.valid_message_chars?('hello world')).to eq(true)
    expect(@enigma.valid_message_chars?('hello world!')).to eq(false)
    expect(@enigma.valid_message_chars?('HELLO')).to eq(false)
    expect(@enigma.valid_message_chars?('good_morning')).to eq(false)
    expect(@enigma.valid_message_chars?('abc xyz')).to eq(true)
  end
end
 