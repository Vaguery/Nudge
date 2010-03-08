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


class CodeAtomQInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_listing = @context.stacks[:code].pop.value
    @arg1 = NudgeProgram.new(arg_listing)
  end
  def derive
    atomQ = @arg1.parses? && @arg1.points == 1
    @result = ValuePoint.new("bool", atomQ)
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
      len = @parsed[1].contents.length
    elsif @parsed.parses? == false
      len = ValuePoint.new("int", 0)
    else
      len = 1
    end
    ValuePoint.new("int", len)
  end
  def cleanup
    pushes :int, @result
  end
end


class CodePointsInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_listing = @context.stacks[:code].pop.value
    @parsed = NudgeProgram.new(arg_listing)
  end
  def derive
    @result = ValuePoint.new("int",@parsed.points)
  end
  def cleanup
    pushes :int, @result
  end
end



class CodeQuoteInstruction < Instruction
  def preconditions?
    needs :exec, 1
  end
  def setup
    next_point = @context.stacks[:exec].pop
    top,bottom = next_point.listing_parts
    @parsed = NudgeProgram.new("#{top.strip}\n#{bottom.strip}")
  end
  def derive
      @result = ValuePoint.new("code", @parsed.listing)
  end
  def cleanup
    pushes :code, @result
  end
end
