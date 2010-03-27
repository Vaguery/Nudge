class CodeNthCdrInstruction < Instruction
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
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot parse the argument" unless tree.parses?
    backbone = tree.linked_code
    if backbone.kind_of?(CodeblockPoint)
      b_len = backbone.contents.length
      if b_len > 0
        new_tree = CodeblockPoint.new(backbone.contents.slice(@arg1 % b_len, b_len))
      else
        new_tree = CodeblockPoint.new([])
      end
    else
      new_tree = @arg1 > 0 ? CodeblockPoint.new([tree.linked_code]) : CodeblockPoint.new([])
    end
    @result = ValuePoint.new("code", new_tree.blueprint)
  end
  def cleanup
    pushes :code, @result
  end
end
