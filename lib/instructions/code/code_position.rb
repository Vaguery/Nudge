class CodePositionInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    looking_for_this = NudgeProgram.new(@arg1).linked_code
    inside_this = NudgeProgram.new(@arg2).linked_code
    if inside_this && looking_for_this
      index = inside_this.find_index {|point| point.blueprint == looking_for_this.blueprint} || -2
    else
      index = -2
    end
    @result = ValuePoint.new("int", index+1)
  end
  def cleanup
    pushes :int, @result
  end
end
