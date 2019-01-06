require 'JSON'
class ColonRocket
  class OverlappingKeysException < StandardError; end

  def self.blastoff(hash)
    detect_collisions(hash.keys)
    puts (hash.to_json)
  end

  def self.detect_collisions(hash_keys)
    if hash_keys.length != hash_keys.map(&:to_s).uniq.length
      duplicate_keys =  hash_keys.map.
                        with_object(Hash.new(0)) { |key, obj| obj[key.to_s] += 1 }.
                        select { |key, val| val > 1 }
      puts "~~~~~duplicate key(s) detected~~~~~: #{duplicate_keys}"
      true
    end
  end

  private_class_method :detect_collisions
end
