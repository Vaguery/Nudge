class Instruction
  attr_reader :context
  
  @@all_instructions = []
  
  def self.inherited(subclass)
    @@all_instructions << subclass
    super
  end
  
  def self.all_instructions
    @@all_instructions
  end
  
  def self.to_nudgecode
    self.to_s.slice(0..-12).underscore
  end
  
  class NotEnoughStackItems < ArgumentError
  end
  
  class InstructionMethodError < RuntimeError
  end
  
  class NaNResultError < RuntimeError
  end
  
  class MissingInstructionError < RuntimeError
  end
  
  def initialize(context)
    @context = context
  end
  
  
  def needs(infrastructure, minimum = 1)
    unless infrastructure.is_a?(Symbol)
      raise(MissingInstructionError, "#{self.class} needs #{infrastructure}") unless
        @context.instructions.include?(infrastructure)
    else
      iNeed = @context.stacks[infrastructure]
      if @context.stacks[infrastructure].depth < minimum
        raise NotEnoughStackItems, "Stack #{infrastructure} too small: needs at least #{minimum} items"
      else
        return true
      end
    end
  end
  
  
  def pushes(stackName, literal)
    @context.stacks[stackName].push literal
  end
  
  
  def go
    if self.preconditions?
      self.setup
      self.derive
      self.cleanup
    end
  rescue NotEnoughStackItems, MissingInstructionError => exc
    msg = ValuePoint.new("error", exc.message)
    pushes :error, msg
  rescue InstructionMethodError
  rescue NaNResultError => exc
    msg = ValuePoint.new("error", exc.message)
    pushes :error, msg
  end
  
  
  def preconditions?
    raise "Your Instruction class should define its own #preconditions? method"
  end
  
  def setup
    raise "Your Instruction class should define its own #setup method"
  end
  
  def derive
    raise "Your Instruction class should define its own #derive method"
  end
  
  def cleanup
    raise "Your Instruction class should define its own #cleanup method"
  end
  
end