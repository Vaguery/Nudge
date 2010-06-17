class Outcome
  include Settings
  
  attr_accessor :points_evaluated
  attr_reader :expiration_moment
  attr_reader :variable_bindings
  attr_reader :stacks
  
  def initialize (variable_bindings)
    @variable_bindings = variable_bindings
    @points_evaluated = 0
    @expiration_moment = Time.now.to_f + TIME_LIMIT
    @stacks = Hash.new {|hash, key| hash[key] = [] }
  end
end
