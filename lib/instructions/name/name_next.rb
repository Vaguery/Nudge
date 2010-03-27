class NameNextInstruction < Instruction
  def preconditions?
    true
  end
  def setup
    @new_name = @context.next_name
  end
  def derive
    @result = ReferencePoint.new(@new_name)
  end
  def cleanup
    pushes :exec, @result
  end
end
