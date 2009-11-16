module PopInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    needs @target_stack, 1
  end
  def setup
    @result = @context.stacks[@target_stack].pop
  end
  def derive
  end
  def cleanup
  end
end


class IntPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :int)
  end
end


class FloatPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :float)
  end
end


class BoolPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :bool)
  end
end






module SwapInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    needs @target_stack, 2
  end
  def setup
    @result1 = @context.stacks[@target_stack].pop
    @result2 = @context.stacks[@target_stack].pop
  end
  def derive
  end
  def cleanup
    pushes @target_stack, @result1
    pushes @target_stack, @result2
  end
end


class IntSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :int)
  end
end


class FloatSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :float)
  end
end


class BoolSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :bool)
  end
end






module DuplicateInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    needs @target_stack, 1
  end
  def setup
    @arg1 = @context.stacks[@target_stack].peek.value
  end
  def derive
    @result = LiteralPoint.new(@target_stack.to_s,@arg1)
  end
  def cleanup
    pushes @target_stack, @result
  end
end


class IntDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :int)
  end
end


class FloatDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :float)
  end
end


class BoolDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :bool)
  end
end






module RotateInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    needs @target_stack, 3
  end
  def setup
    @arg3 = @context.stacks[@target_stack].pop
    @arg2 = @context.stacks[@target_stack].pop
    @arg1 = @context.stacks[@target_stack].pop
  end
  def derive
  end
  def cleanup
    pushes @target_stack, @arg2
    pushes @target_stack, @arg3
    pushes @target_stack, @arg1
  end
end


class IntRotateInstruction < Instruction
  include RotateInstruction
  def initialize(context)
    super(context, :int)
  end
end


class FloatRotateInstruction < Instruction
  include RotateInstruction
  def initialize(context)
    super(context, :float)
  end
end


class BoolRotateInstruction < Instruction
  include RotateInstruction
  def initialize(context)
    super(context, :bool)
  end
end






module DepthInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    @context.stacks[@target_stack].depth != nil
  end
  def setup
  end
  def derive
    @result = LiteralPoint.new("int",@context.stacks[@target_stack].depth)
  end
  def cleanup
    pushes :int, @result
  end
end


class IntDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :int)
  end
end


class FloatDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :float)
  end
end


class BoolDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :bool)
  end
end







module FlushInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    @context.stacks[@target_stack].depth != nil
  end
  def setup
  end
  def derive
  end
  def cleanup
    @context.stacks[@target_stack].clear
  end
end



class IntFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :int)
  end
end



class FloatFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :float)
  end
end


class BoolFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :bool)
  end
end

