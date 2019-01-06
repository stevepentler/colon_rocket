require 'rspec'
require_relative '../lib/colon_rocket.rb'

describe 'ColonRocket', type: :model do
  let(:overlapping_exception_message) { 'Collision detected, identical key found as String and Symbol, example { a: "B", "a" => "NOT B" }' }
  let(:symbolized_keys) { { a: :b } }
  let(:string_keys)     { { "a" => "b" } }
  let(:mixed_keys)      { { "a" => "b", c: :d } }
  let(:colliding_keys)  { { a: 1, "a" => 2 } }
  let(:nested)          { { "a" => { b: { "c" => :d } } } }

  describe 'blastoff' do
    context 'symbolized keys' do
      it 'puts valid json' do
        expect(STDOUT).to receive(:puts).with("{\"a\":\"b\"}")
        expect(ColonRocket.blastoff(symbolized_keys)).to eq(nil)
      end
    end

    context 'string keys' do
      it 'puts valid json' do
        expect(STDOUT).to receive(:puts).with("{\"a\":\"b\"}")
        expect(ColonRocket.blastoff(string_keys)).to eq(nil)
      end
    end

    context 'mixed keys' do
      it 'puts valid json' do
        expect(STDOUT).to receive(:puts).with("{\"a\":\"b\",\"c\":\"d\"}")
        expect(ColonRocket.blastoff(mixed_keys)).to eq(nil)
      end
    end

    context 'nested hashes' do
      it 'puts valid json' do
        expect(STDOUT).to receive(:puts).with("{\"a\":{\"b\":{\"c\":\"d\"}}}")
        expect(ColonRocket.blastoff(nested)).to eq(nil)
      end
    end

    context 'edge cases' do
      context 'hash rocket inside value is not overridden' do
        let(:rocket_in_value) { { "a" => " => this has a hash rocket => "}}
        it 'puts valid json' do
          expect(STDOUT).to receive(:puts).with("{\"a\":\" => this has a hash rocket => \"}")
          expect(ColonRocket.blastoff(rocket_in_value)).to eq(nil)
        end
      end
    end
  end

  describe 'private methods' do
    describe 'detect_collisions' do
      context 'unique keys' do
        let(:hash_keys) { ["a", "b"] }
        it 'returns nil' do
          expect(ColonRocket.send(:detect_collisions, hash_keys)).to eq(nil)
        end
      end

      context 'clashing symbol' do
        let(:hash_keys) { [:a, :a] }
        it 'returns true' do
          expect(STDOUT).to receive(:puts).with("~~~~~duplicate key(s) detected~~~~~: {\"a\"=>2}")
          expect(ColonRocket.send(:detect_collisions, hash_keys)).to eq(true)
        end
      end

      context 'clashing string' do
        let(:hash_keys) { ["a", "a"] }
        it 'returns true' do
          expect(STDOUT).to receive(:puts).with("~~~~~duplicate key(s) detected~~~~~: {\"a\"=>2}")
          expect(ColonRocket.send(:detect_collisions, hash_keys)).to eq(true)
        end
      end

      context 'clashing mix, string first' do
        let(:hash_keys) { ["a", :a] }
        it 'returns true' do
          expect(STDOUT).to receive(:puts).with("~~~~~duplicate key(s) detected~~~~~: {\"a\"=>2}")
          expect(ColonRocket.send(:detect_collisions, hash_keys)).to eq(true)
        end
      end

      context 'clashing mix, symbol first' do
        let(:hash_keys) { [:a, "a"] }
        it 'returns true' do
          expect(STDOUT).to receive(:puts).with("~~~~~duplicate key(s) detected~~~~~: {\"a\"=>2}")
          expect(ColonRocket.send(:detect_collisions, hash_keys)).to eq(true)
        end
      end

      context 'multiple collisions' do
        let(:hash_keys) { [:a, "a", "b", "b", :b, :d] }
        it 'returns true' do
          expect(STDOUT).to receive(:puts).with("~~~~~duplicate key(s) detected~~~~~: {\"a\"=>2, \"b\"=>3}")
          expect(ColonRocket.send(:detect_collisions, hash_keys)).to eq(true)
        end
      end
    end
  end
end
