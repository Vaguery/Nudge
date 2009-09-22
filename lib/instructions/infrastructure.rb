class Instruction
  class NotEnoughStackItems < ArgumentError
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
  
  def preconditions?
    raise "Your Instruction class should define its own #preconditions method"
  end
  
  def go
    raise "Your Instruction class should define its own #go method"
  end
  
  def outcomes
    raise "Your Instruction class should define its own #effects method"
  end
  
end