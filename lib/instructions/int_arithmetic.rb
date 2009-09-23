require 'singleton'

class IntAddInstruction < Instruction
  include Singleton
  
  def preconditions?
    needs :int, 2
  end
  
  def setup
    @arg1 = Stack.stacks[:int].pop
    @arg2 = Stack.stacks[:int].pop
  end
  
  def derive
    @result = LiteralPoint.new("int", @arg1.value + @arg2.value)
  end
  
  def cleanup
    pushes :int, @result
  end
end

class IntMultiplyInstruction < Instruction
  include Singleton
  
  def preconditions?
    needs :int, 2
  end
  
  def setup
    @arg1 = Stack.stacks[:int].pop
    @arg2 = Stack.stacks[:int].pop
  end
  
  def derive
    @result = LiteralPoint.new("int", @arg1.value * @arg2.value)
  end
  
  def cleanup
    pushes :int, @result
  end
end