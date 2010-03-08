class CodeNoopInstruction < Instruction
  def preconditions?
    true
  end

  def setup
  end

  def derive
  end

  def cleanup
  end
end


class CodeNullQInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_listing = @context.stacks[:code].pop.value
    @arg1 = NudgeProgram.new(arg_listing).listing
  end
  def derive
    @result = ValuePoint.new("bool", @arg1 == "block {}")
  end
  def cleanup
    pushes :bool, @result
  end
end


class CodeLengthInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_listing = @context.stacks[:code].pop.value
    @parsed = NudgeProgram.new(arg_listing)
  end
  def derive
    if @parsed.linked_code kind_of?(CodeblockPoint)
      @result = ValuePoint.new("int", @parsed[1].contents.length)
    elsif @parsed.parses? == false
      @result = 0
    else
      @result = 1
    end
  end
  def cleanup
    pushes :int, @result
  end
end


# class BoolOrInstruction < Instruction
#   def preconditions?
#     needs :bool, 2
#   end
#   def setup
#     @arg1 = @context.stacks[:bool].pop.value
#     @arg2 = @context.stacks[:bool].pop.value
#   end
#   def derive
#     @result = ValuePoint.new("bool", @arg1 || @arg2)
#   end
#   def cleanup
#     pushes :bool, @result
#   end
# end
