class CodeCarInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    @arg = @context.pop_value(:code)
  end
  def derive
    tree = NudgeProgram.new(@arg)
    if tree.linked_code.kind_of?(CodeblockPoint) && (tree.points > 2)
      new_tree = tree[1].contents[0]
    else
      new_tree = tree
    end
    @result = ValuePoint.new("code", new_tree.blueprint)
  end
  def cleanup
    pushes :code, @result
  end
end
