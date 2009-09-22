require 'singleton'

class IntAddInstruction < Instruction
  include Singleton
  
  def preconditions?
    needs :int, 2
  end
  
  def go
    self.preconditions?
    
    arg1 = Stack.stacks[:int].pop
    arg2 = Stack.stacks[:int].pop
    @result = LiteralPoint.new("int", arg1.value + arg2.value)
    
    self.outcomes
  end
  
  def outcomes
    pushes :int, @result
  end
  
end