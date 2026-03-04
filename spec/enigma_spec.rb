require './lib/enigma'

RSpec.describe 'Enigma'do
  before(:each) do
    @enigma = Enigma.new
  end

  it 'exists' do

  expect(@enigma).to be_an(Object)
  end
end