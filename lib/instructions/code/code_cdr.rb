class CodeCdrInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    @arg = @context.pop_value(:code)
  end
  def derive
    tree = NudgeProgram.new(@arg)
    if tree.linked_code.kind_of?(CodeblockPoint) && (tree.points > 2)
      new_tree = tree.delete_point(2)
    else
      new_tree = CodeblockPoint.new([])
    end
    @result = ValuePoint.new("code", new_tree.blueprint)
  end
  def cleanup
    pushes :code, @result
  end
end
