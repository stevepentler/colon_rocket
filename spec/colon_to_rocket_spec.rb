require 'rspec'
require_relative '../lib/colon_rocket.rb'

describe 'ColonRocket', type: :model do
  let(:overlapping_exception_message) { 'Collision detected, identical key found as String and Symbol, example { a: "B", "a" => "NOT B" } Pass in a second argument of true (boolean) to overwrite to the final positional value' }
  let(:symbolized_keys) { { a: :b } }
  let(:string_keys)     { { "a" => "b" } }
  let(:mixed_keys)      { { "a" => "b", c: :d } }
  let(:colliding_keys)  { { a: 1, "a" => 2 } }

  describe 'blastoff' do
    context 'symbolized keys' do
      it 'puts valid json' do
        expect(STDOUT).to receive(:puts).with("{\"a\": \"b\"}")
        expect(ColonRocket.blastoff(symbolized_keys)).to eq(nil)
      end
    end

    context 'string keys' do
      it 'puts valid json' do
        expect(STDOUT).to receive(:puts).with("{\"a\": \"b\"}")
        expect(ColonRocket.blastoff(string_keys)).to eq(nil)
      end
    end

    context 'mixed keys' do
      it 'puts valid json' do
        expect(STDOUT).to receive(:puts).with("{\"a\": \"b\", \"c\": \"d\"}")
        expect(ColonRocket.blastoff(mixed_keys)).to eq(nil)
      end
    end

    context 'collision handling' do
      context 'collision' do
        context 'overwrite_collisions is false' do
          it 'default raises OverlappingKeysException' do
            expect { ColonRocket.blastoff(colliding_keys) }.to raise_exception(overlapping_exception_message)
          end

          it 'when passed in as arg, raises OverlappingKeysException' do
            expect { ColonRocket.blastoff(colliding_keys, false) }.to raise_exception(overlapping_exception_message)
          end
        end

        context 'overwrite_collisions is true' do
          context 'print collisions is true' do
            it 'prints colision detection message and puts json' do
              expect(STDOUT).to receive(:puts).with("Collision detected, reassigning \"a\" from 1 to 2")
              expect(STDOUT).to receive(:puts).with("{\"a\": \"2\"}")
              expect(ColonRocket.blastoff(colliding_keys, true)).to eq(nil)
            end
          end

          context 'print collisions is false' do
            it 'does not print collision detected message and puts json' do
              expect(STDOUT).to_not receive(:puts).with("Collision detected, reassigning \"a\" from 1 to 2")
              expect(STDOUT).to receive(:puts).with("{\"a\": \"2\"}")
              expect(ColonRocket.blastoff(colliding_keys, true, false)).to eq(nil)
            end
          end
        end
      end
    end

    context 'edge cases' do
      context 'hash rocket inside value is not overridden' do
        let(:rocket_in_value) { { "a" => " => this has a hash rocket => "}}
        it 'puts valid json' do
          expect(STDOUT).to receive(:puts).with("{\"a\": \" => this has a hash rocket => \"}")
          expect(ColonRocket.blastoff(rocket_in_value)).to eq(nil)
        end
      end
    end
  end

  describe 'private methods' do
    describe 'collision_detected' do
      let(:obj) { { "a" => "1" } }
      context 'unique keys' do
        let(:val) { [:z, 1] }
        it 'returns false' do
          expect(ColonRocket.send(:collision_detected, val, obj)).to eq(false)
        end
      end

      context 'clashing symbol' do
        let(:val) { [:a, 2] }
        it 'returns true' do
          expect(ColonRocket.send(:collision_detected, val, obj)).to eq(true)
        end
      end

      context 'clashing string' do
        let(:val) { ["a", 2] }
        it 'returns true' do
          expect(ColonRocket.send(:collision_detected, val, obj)).to eq(true)
        end
      end
    end

    describe 'handle_collision' do
      let(:obj) { { "a" => 1 } }
      let(:val) { ["a", 2] }
      context 'overwrite_collisions is false' do
        it 'raises Exception' do
          expect { ColonRocket.send(:handle_collision, val, obj, false, true) }.to raise_exception(overlapping_exception_message)
        end
      end

      context 'overwite_collisions is true' do
        context 'print collisions is true' do
          it 'prints collisions and returns nil' do
            expect(STDOUT).to receive(:puts).with("Collision detected, reassigning \"a\" from 1 to 2")
            expect(ColonRocket.send(:handle_collision, val, obj, true, true)).to eq(nil)
          end
        end

        context 'print collisions is false' do
          it 'prints collisions' do
            expect(STDOUT).to_not receive(:puts).with("Collision detected, reassigning \"a\" from 1 to 2")
            expect(ColonRocket.send(:handle_collision, val, obj, true, false)).to eq(nil)
          end
        end
      end
    end
  end
end
