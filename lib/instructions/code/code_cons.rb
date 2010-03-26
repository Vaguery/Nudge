# This is a tricky one to translate from Push, which assumes a very Lisp-like list structure. Here we'll simply build a new block with the consed item first, and the original code second.

class CodeConsInstruction < Instruction
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
      consed_tree = t2.insert_point_before(1,t1.linked_code)
    else
      raise InstructionMethodError,
        "#{self.class.to_nudgecode} cannot parse the arguments"
    end
    @result = ValuePoint.new("code", consed_tree.listing)
  end
  def cleanup
    pushes :code, @result
  end
end
