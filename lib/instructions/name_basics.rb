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

class NameDisableLookupInstruction < Instruction
  def preconditions?
    true
  end
  def setup
  end
  def derive
  end
  def cleanup
    @context.evaluate_references = false
  end
end

