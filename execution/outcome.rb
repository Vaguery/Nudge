# encoding: UTF-8
class Outcome
  include Settings
  
  attr_accessor :points_evaluated
  attr_accessor :execution_time
  attr_reader :variable_bindings
  attr_reader :start_moment
  attr_reader :stacks
  attr_accessor :wtf_stacks
  
  def initialize (variable_bindings)
    @points_evaluated = 0
    @execution_time = 0
    @variable_bindings = variable_bindings
    @stacks = Hash.new {|hash, key| hash[key] = [] }
    @wtf_stacks = Hash.new {|hash, key| hash[key] = [] }
  end
  
  def begin
    @start_moment = Time.now.to_f
    self
  end
  
  def end
    @execution_time = Time.now.to_f - @start_moment
    self
  end
end
