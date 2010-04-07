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
  
  class CodeOversizeError < ArgumentError
  end
  
  
  def initialize(context)
    @context = context
  end
  
  
  def needs(infrastructure, minimum = 1)
    unless infrastructure.is_a?(Symbol)
      raise(InstructionNotFoundError, "#{infrastructure.to_s} is not a known Instruction") unless
        Object.const_defined?(infrastructure.to_s)
      raise(MissingInstructionError, "#{self.class} needs #{infrastructure}") unless
        @context.instructions.include?(infrastructure)
    else
      iNeed = @context.stacks[infrastructure]
      if @context.stacks[infrastructure].depth < minimum
        raise NotEnoughStackItems,
          "Stack #{infrastructure.to_s} too small: #{self.class.to_nudgecode} needs at least #{minimum} items"
      end
    end
    return true
  end
  
  
  def pushes(stackName, literal)
    if (stackName.to_s == "code") && (literal.value.length > self.context.code_char_limit)
      raise(CodeOversizeError, ":code cannot have more than #{self.context.code_char_limit} chars")
    end
    @context.stacks[stackName].push literal
  end
  
  
  def go
    if self.preconditions?
      self.setup
      self.derive
      self.cleanup
    end
  rescue NotEnoughStackItems, MissingInstructionError,
    InstructionMethodError, NaNResultError, FloatDomainError, CodeOversizeError => exc
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



module IfInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    needs @target_stack, 2
    needs :bool, 1
  end
  def setup
    @stay = @context.pop_value(:bool)
    @ifFalse = @context.pop(@target_stack)
    @ifTrue = @context.pop(@target_stack)
  end
  def derive
  end
  def cleanup
    @stay ? @context.stacks[@target_stack].push(@ifTrue) : @context.stacks[@target_stack].push(@ifFalse)
  end
end


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
    @result = @context.pop(@target_stack)
  end
  def derive
  end
  def cleanup
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
    @result1 = @context.pop(@target_stack)
    @result2 = @context.pop(@target_stack)
  end
  def derive
  end
  def cleanup
    pushes @target_stack, @result1
    pushes @target_stack, @result2
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
    @arg1 = @context.peek(@target_stack)
  end
  def derive
    @result = @arg1.clone
  end
  def cleanup
    pushes @target_stack, @result
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
    @arg3 = @context.pop(@target_stack)
    @arg2 = @context.pop(@target_stack)
    @arg1 = @context.pop(@target_stack)
  end
  def derive
  end
  def cleanup
    pushes @target_stack, @arg2
    pushes @target_stack, @arg3
    pushes @target_stack, @arg1
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
    @result = ValuePoint.new("int",@context.stacks[@target_stack].depth.to_s)
  end
  def cleanup
    pushes :int, @result
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


module ShoveInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    if @target_stack != :int
      needs :int, 1
      needs @target_stack, 1
    else
      needs :int, 2
    end
  end
  
  def setup
    @how_far = @context.pop_value(:int)
    @result = @context.pop(@target_stack)
  end
  
  def derive
    max = @context.stacks[@target_stack].depth
    case 
    when @how_far <= 0
      @new_depth = max
    when @how_far > max
      @new_depth = 0
    else
      @new_depth = max - @how_far
    end
  end
  
  def cleanup
    @context.stacks[@target_stack].entries.insert(@new_depth,@result)
  end
end


module YankInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    if @target_stack != :int
      needs :int, 1
      needs @target_stack, 1
    else
      needs :int, 2
    end
  end
  
  def setup
    @from_where = @context.pop_value(:int)
  end
  
  def derive
    max = @context.stacks[@target_stack].depth-1
    case 
    when @from_where < 0
      @which = max
    when @from_where > max
      @which = 0
    else
      @which = max - @from_where 
    end
  end
  
  def cleanup
    moved_value = @context.stacks[@target_stack].entries.delete_at(@which)
    @context.stacks[@target_stack].push(moved_value)
  end
end


module YankdupInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    if @target_stack != :int
      needs :int, 1
      needs @target_stack, 1
    else
      needs :int, 2
    end
  end
  
  def setup
    @from_where = @context.pop_value(:int)
  end
  
  def derive
    max = @context.stacks[@target_stack].depth-1
    case 
    when @from_where < 0
      @which = max
    when @from_where > max
      @which = 0
    else
      @which = max - @from_where 
    end
  end
  
  def cleanup
    moved_value = @context.stacks[@target_stack].entries[@which].clone
    @context.stacks[@target_stack].push(moved_value)
  end
end


module DefineInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    if @target_stack != :name
      needs @target_stack, 1
      needs :name, 1
    else
      needs :name, 2
    end
  end
  
  def setup
    @bound_name = @context.pop_value(:name)
    @new_value =  @context.pop(@target_stack)
  end
  
  def derive
    raise Instruction::InstructionMethodError, "#{self.class} cannot redefine a variable" if
      @context.variables[@bound_name] != nil
  end
  
  def cleanup
    @context.bind_name(@bound_name, @new_value)
  end
end
