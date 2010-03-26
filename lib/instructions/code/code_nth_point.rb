class CodeNthPointInstruction < Instruction # was CODE.EXTRACT in Push3
  def preconditions?
    needs :int, 1
    needs :code, 1
  end
  def setup
    @arg1 = @context.pop_value(:int)
    @arg2 = @context.pop_value(:code)
  end
  def derive
    tree = NudgeProgram.new(@arg2)
    tree_size = tree.points
    raise InstructionMethodError, "#{self.class} divied by zero" if tree_size < 1
    which = (@arg1-1) % tree_size + 1
    pt = tree[which]
    @result = ValuePoint.new("code", pt.listing)
  end
  def cleanup
    pushes :code, @result
  end
end
