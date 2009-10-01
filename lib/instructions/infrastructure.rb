class Instruction
  require 'singleton'
  include Singleton
  
  
  class NotEnoughStackItems < ArgumentError
  end
  
  class InstructionMethodError < RuntimeError
  end
  
  def needs(stackName, minimum)
    iNeed = Stack.stacks[stackName]
    
    if Stack.stacks[stackName].depth < minimum
       raise NotEnoughStackItems
      return false
    else
      return true
    end
  end

  def pushes(stackName, literal)
    Stack.stacks[stackName].push literal
  end
  
  def go
    begin
    if self.preconditions?
      self.setup
      self.derive
      self.cleanup
    end
    rescue NotEnoughStackItems
      logError("NOOP: Parameter shortage")
    rescue InstructionMethodError
       logError("NOOP: Calculation error")
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
  
  def logError(msg)
    # STDERR.puts msg
  end
  
end