class CodeNthInstruction < Instruction 
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
    if tree.linked_code.kind_of?(CodeblockPoint)
      pts = tree[1].contents.length
      raise InstructionMethodError, "#{self.class} can't work on empty blocks" if pts < 1
      val = tree[1].contents[@arg1 % pts]
    else
      val = tree
    end
    @result = ValuePoint.new("code", val.blueprint)
  end
  def cleanup
    pushes :code, @result
  end
end
