require 'spec_helper'
require './lib/enigma'

RSpec.describe Enigma do
  let(:enigma) { described_class.new }
  let(:key) { '02715' }
  let(:date) { '040895' }

  describe '#encrypt' do
    it 'encrypts message with spaces and valid chars, leaving punctuation in place' do
      result = enigma.encrypt('hello world!', key, date)

      expect(result).to eq({
        encryption: 'keder ohulw!',
        key: key,
        date: date
      })
    end

    it 'preserves uppercase letters while shifting' do
      result = enigma.encrypt('HELLO world', key, date)

      expect(result[:encryption]).to eq('KEDER ohulw')
    end

    it 'uses generated key and today date when values are omitted' do
      allow(Date).to receive(:today).and_return(Date.new(1995, 8, 4))

      result = enigma.encrypt('hello world')

      expect(result[:key]).to match(/\A\d{5}\z/)
      expect(result[:date]).to eq('040895')
      expect(result[:encryption]).to be_a(String)
    end

    it 'raises an error when an invalid key is provided' do
      expect { enigma.encrypt('hi', '1234', date) }.to raise_error(ArgumentError)
    end

    it 'raises an error when an invalid date is provided' do
      expect { enigma.encrypt('hi', key, 'bad') }.to raise_error(ArgumentError)
    end
  end

  describe '#decrypt' do
    it 'decrypts message with provided key and date' do
      ciphertext = enigma.encrypt('hello world', key, date)[:encryption]

      expect(enigma.decrypt(ciphertext, key, date)).to eq({
        decryption: 'hello world',
        key: key,
        date: date
      })
    end

    it 'decrypts message with uppercase letters preserved' do
      ciphertext = enigma.encrypt('HELLO world', key, date)[:encryption]

      expect(enigma.decrypt(ciphertext, key, date)[:decryption]).to eq('HELLO world')
    end

    it 'does not generate a key when missing for decrypt' do
      ciphertext = enigma.encrypt('test message', key, date)[:encryption]

      expect { enigma.decrypt(ciphertext, nil, date) }.to raise_error(ArgumentError)
    end
  end

  describe '#crack' do
    it 'brute forces the key using the known suffix' do
      encrypted = enigma.encrypt('hello world end', key, date)[:encryption]

      result = enigma.crack(encrypted, date)

      expect(result[:decryption]).to eq('hello world end')
      expect(result[:key]).to eq(key)
      expect(result[:date]).to eq(date)
    end

    it 'raises an error if a key cannot be found' do
      allow(enigma).to receive(:find_key).and_return(nil)

      expect { enigma.crack('!!!', date) }.to raise_error(ArgumentError)
    end
  end

  describe 'file helpers' do
    it 'encrypts and decrypts file contents while leaving punctuation untouched' do
      Dir.mktmpdir do |dir|
        input = File.join(dir, 'input.txt')
        encrypted_output = File.join(dir, 'encrypted.txt')
        decrypted_output = File.join(dir, 'decrypted.txt')
        File.write(input, 'Hello, world!')

        encrypt_result = enigma.encrypt_file(input, encrypted_output, key, date)
        decrypt_result = enigma.decrypt_file(encrypted_output, decrypted_output, key, date)

        expect(encrypt_result[:encryption]).to eq('Keder, ohulw!')
        expect(decrypt_result[:decryption]).to eq('Hello, world!')
        expect(File.read(decrypted_output)).to eq('Hello, world!')
      end
    end
  end
end
