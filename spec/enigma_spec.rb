require 'spec_helper'
require './lib/enigma'

RSpec.describe Enigma do
  before(:each) do
    @enigma = Enigma.new
  end

  it 'exists' do
    expect(@enigma).to be_an_instance_of(Enigma)
  end

  it 'can encypt a message with a key and date' do

   result = @enigma.encrypt("hello world", "02715", "040895")

   expect(result).to eq({
    encryption: "keder ohulw",
    key: "02715",
    date: "040895"
   })
  end
end