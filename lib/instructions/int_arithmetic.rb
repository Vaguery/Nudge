require 'singleton'

class IntAddInstruction < Instruction
  include Singleton
  
  attr :result
  
  def preconditions?
    needs :int, 2
  end
  
  def go
    self.preconditions?
    
    begin
      arg1 = Stack.stacks[:int].pop
      arg2 = Stack.stacks[:int].pop
      @result = LiteralPoint.new("int", arg1.value + arg2.value)
    end
    
    self.outcomes
  end
  
  def outcomes
    pushes :int, @result
  end
  
end

class IntMultiplyInstruction < Instruction
  include Singleton
  
  attr :result
  
  def preconditions?
    needs :int, 2
  end
  
  def go
    self.preconditions?
    
    begin
      arg1 = Stack.stacks[:int].pop
      arg2 = Stack.stacks[:int].pop
      @result = LiteralPoint.new("int", arg1.value * arg2.value)
    end
    
    self.outcomes
  end
  
  def outcomes
    pushes :int, @result
  end
  
end