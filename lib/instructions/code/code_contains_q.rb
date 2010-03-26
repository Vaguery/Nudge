class CodeContainsQInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    looking_for_this = NudgeProgram.new(@arg1)
    tree = NudgeProgram.new(@arg2)
    if tree.parses? && looking_for_this.parses?
      found = tree.linked_code.any? {|point| point.listing == looking_for_this.listing}
    else
      found = false
    end
    @result = ValuePoint.new("bool", found)
  end
  def cleanup
    pushes :bool, @result
  end
end
