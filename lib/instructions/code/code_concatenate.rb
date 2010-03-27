class CodeConcatenateInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    t1 = NudgeProgram.new(@arg1)
    t2 = NudgeProgram.new(@arg2)
    if t1.parses? && t2.parses?
      if t1.linked_code.kind_of?(CodeblockPoint)
        if t2.linked_code.kind_of?(CodeblockPoint)
          new_tree = t1[1].contents + t2[1].contents
        else
          new_tree = t1[1].contents << t2.linked_code
        end
      else
        new_tree = [t1.linked_code, t2.linked_code]
      end
      listed = CodeblockPoint.new(new_tree).blueprint
      @result = ValuePoint.new("code", listed)
    else
      @result = ValuePoint.new("code", "block {}")
    end
  end
  def cleanup
    pushes :code, @result
  end
end
