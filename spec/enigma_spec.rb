  require './lib/enigma'
  require 'stringio'

  RSpec.describe 'Enigma' do
    it 'can shift a single letter correctly' do
      final_shifts = { A: 3, B: 27, C: 73, D: 20 }
      expect(@enigma.shift_letter('h', 0, final_shifts)).to eq('k')
      expect(@enigma.shift_letter('e', 1, final_shifts)).to eq('e') # wraps around
      expect(@enigma.shift_letter('l', 2, final_shifts)).to eq('d')
      expect(@enigma.shift_letter('l', 3, final_shifts)).to eq('e')
      expect(@enigma.shift_letter(' ', 4, final_shifts)).to eq('r')
      # Non-char_set character (e.g. '!') should not shift
      expect(@enigma.shift_letter('!', 5, final_shifts)).to eq('!')
    end

    it 'can apply shifts to a message' do
      final_shifts = { A: 3, B: 27, C: 73, D: 20 }
      @enigma.instance_variable_set(:@message, 'hello world'.split(''))
      @enigma.instance_variable_set(:@new_message, [])
      result = @enigma.apply_shifts(final_shifts)
      expect(result).to eq('keder ohulw')
    end
  before(:each) do
    input = StringIO.new("hello world\n040895\n02715\n")
    @orig_stdin = $stdin
    $stdin = input
    @enigma = Enigma.new
  end

  after(:each) do
    $stdin = @orig_stdin
  end

  it 'exists' do
    expect(@enigma).to be_an(Object)
  end

  it 'can encrypt a message with a key and date' do 
    expect(@enigma.encrypt).to eq(
      {
        encryption: "keder ohulw",
        key: "02715",
        date: "040895"
      })
  end

  it 'can create date shifts' do
    date = '040895'
    
    expect(@enigma.date_shifts(date)).to eq(
      {
        A:'1',
        B:'0',
        C:'2',
        D:'5'
      })
  end

  it 'squares the dates' do
    date = "040895"
    expect(@enigma.squares_date(date)).to eq(1672401025)
  end

  it 'can get last four digits of a number' do
    num = 1672401025

    expect(@enigma.last_four(num)).to eq('1025')
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

  it 'can caluclate final shifts' do
    date_shifts = { A:'1', B:'0', C:'2', D:'5' }
    key_shifts  = { A: '02', B: '27', C: '71', D: '15' }
    
    expect(@enigma.final_shifts(date_shifts, key_shifts)).to eq(
      {:A=>3, :B=>27, :C=>73, :D=>20}
      )
  end

  it "can sum a single shift pair" do
    date_value = { A: "1", B: "0", C: "2", D: "5" }
    key_value  = { A: "02", B: "27", C: "71", D: "15" }

    date_shifts = { A:'1', B:'0', C:'2', D:'5' }
    key_shifts  = { A: '02', B: '27', C: '71', D: '15' }

    expect(@enigma.sum_shift_pair(date_value[:A], key_value[:A])).to eq(3)
    expect(@enigma.sum_shift_pair(date_value[:B], key_value[:B])).to eq(27)
    expect(@enigma.sum_shift_pair(date_value[:C], key_value[:C])).to eq(73)
    expect(@enigma.sum_shift_pair(date_value[:D], key_value[:D])).to eq(20)
  end
 
  it 'can return encrypted message' do
    date_shifts = { A: '1', B: '0', C: '2', D: '5' }
    key_shifts  = { A: '02', B: '27', C: '71', D: '15' }
    expect(@enigma.message_encrypted(date_shifts, key_shifts)).to eq("keder ohulw")
  end
end