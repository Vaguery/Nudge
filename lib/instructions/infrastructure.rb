class Instruction
  
  class NotEnoughStackItems < ArgumentError
  end
  
  class InstructionMethodError < RuntimeError
  end
  
  def needs(stackName, minimum)
    if Stack.stacks[stackName].depth < minimum
      raise NotEnoughStackItems
    else
      return true
    end
  end

  def pushes(stackName, literal)
    Stack.stacks[stackName].push literal
  end
  
  def go
    if self.preconditions?
      self.setup
      self.derive
      self.cleanup
    end
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