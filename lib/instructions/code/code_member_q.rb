class CodeMemberQInstruction < Instruction
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
      if tree.linked_code.kind_of?(CodeblockPoint)
        found = tree[1].contents.any? {|branch| branch.blueprint == looking_for_this.blueprint}
      else
        found = (tree.blueprint == looking_for_this.blueprint)
      end
    else
      found = false
    end
    @result = ValuePoint.new("bool", found)
  end
  def cleanup
    pushes :bool, @result
  end
end
