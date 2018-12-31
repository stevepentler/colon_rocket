class ColonRocket
  class OverlappingKeysException < StandardError; end

  def self.blastoff(hash, overwrite_collisions=false, print_collisions=true)
    json = hash.map.with_object({}) do |val, obj|
      handle_collision(val, obj, overwrite_collisions, print_collisions) if collision_detected(val, obj)
      obj[val.first.to_s] = val.last.to_s
    end.to_s.gsub("\"=>\"", "\": \"")
    puts json
  end

  # private - must be explicitly defined for class methods

  def self.collision_detected(val, obj)
    stringified_key = val.first.to_s
    obj.has_key?(stringified_key)
  end

  def self.handle_collision(val, obj, overwrite_collisions, print_collisions)
    if overwrite_collisions == false
      raise OverlappingKeysException, 'Collision detected, identical key found as String and Symbol, example { a: "B", "a" => "NOT B" } Pass in a second argument of true (boolean) to overwrite to the final positional value'
    elsif print_collisions == true
      stringified_key = val.first.to_s
      puts "Collision detected, reassigning \"#{stringified_key}\" from #{obj[stringified_key]} to #{val.last.to_s}"
    end
  end

  private_class_method :collision_detected, :handle_collision
end
