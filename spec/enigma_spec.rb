require 'spec_helper'
require './lib/enigma'

RSpec.describe Enigma do
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

  # it 'splits a 5-digit key into A, B, C, D keys' do
  #   key = "02715"
  #   result = @enigma.split_keys(key)
  #   expect(result).to eq({
  #     a: "02",
  #     b: "27",
  #     c: "71",
  #     d: "15"
  #   })
  # end
  
  # it 'squares the date' do
  #   result = @enigma.square_date(@date)
  #   expect(result).to eq(1672401025)
  # end

  # it 'extracts the last four digits from the squared date' do
  #   result = @enigma.extract_date(@date)
  #   expect(result).to eq("1025")

  # end
end
 