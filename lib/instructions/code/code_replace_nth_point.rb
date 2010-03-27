class CodeReplaceNthPointInstruction < Instruction # was CODE.INSERT in Push3
  def preconditions?
    needs :int, 1
    needs :code, 2
  end
  def setup
    @where = @context.pop_value(:int)
    @accept = @context.pop_value(:code)
    @insert = @context.pop_value(:code)
  end
  def derive
    acceptor = NudgeProgram.new(@accept)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot work with unparseable code" unless acceptor.parses?
    insertion = NudgeProgram.new(@insert)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot work with unparseable code" unless insertion.parses?
    scale = acceptor.points
    which_pt = if @where < 1 || @where > scale
      (@where % acceptor.points) + 1
    else
      @where
    end
    new_tree = acceptor.replace_point(which_pt, insertion.linked_code).blueprint
    @result = ValuePoint.new("code", new_tree)
  end
  def cleanup
    pushes :code, @result
  end
end
