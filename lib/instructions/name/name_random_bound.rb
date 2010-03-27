class NameRandomBoundInstruction < Instruction
  def preconditions?
    @context.references.length > 0
  end
  def setup
  end
  def derive
    @result = ReferencePoint.new("placeholder")
    @result.randomize(@context)
  end
  def cleanup
    pushes :exec, @result
  end
end
