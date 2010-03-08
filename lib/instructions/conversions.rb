#encoding: utf-8
class IntFromBoolInstruction < Instruction
  def preconditions?
    needs :bool, 1
  end
  def setup
    @arg = @context.stacks[:bool].pop.value
  end
  def derive
    @result = ValuePoint.new("int", @arg ? 1 : 0)
  end
  def cleanup
    pushes :int, @result
  end
end


class FloatFromBoolInstruction < Instruction
  def preconditions?
    needs :bool, 1
  end
  def setup
    @arg = @context.stacks[:bool].pop.value
  end
  def derive
    @result = ValuePoint.new("float", @arg ? 1.0 : 0.0)
  end
  def cleanup
    pushes :float, @result
  end
end


class CodeFromBoolInstruction < Instruction
  def preconditions?
    needs :bool, 1
  end
  def setup
    @arg = @context.stacks[:bool].pop.value
  end
  def derive
    @result = ValuePoint.new("code", "value «bool»\n«bool» #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end



class IntFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg = @context.stacks[:float].pop.value
  end
  def derive
    @result = ValuePoint.new("int", @arg.to_i)
  end
  def cleanup
    pushes :int, @result
  end
end


class FloatFromIntInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg = @context.stacks[:int].pop.value
  end
  def derive
    @result = ValuePoint.new("float", @arg.to_f)
  end
  def cleanup
    pushes :float, @result
  end
end


class BoolFromIntInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg = @context.stacks[:int].pop.value
  end
  def derive
    @result = ValuePoint.new("bool", @arg != 0)
  end
  def cleanup
    pushes :bool, @result
  end
end


class CodeFromIntInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg = @context.stacks[:int].pop.value
  end
  def derive
    @result = ValuePoint.new("code", "value «int»\n«int» #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end




class BoolFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg = @context.stacks[:float].pop.value
  end
  def derive
    @result = ValuePoint.new("bool", @arg != 0.0)
  end
  def cleanup
    pushes :bool, @result
  end
end


class CodeFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg = @context.stacks[:float].pop.value
  end
  def derive
    @result = ValuePoint.new("code", "value «float»\n«float» #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end

