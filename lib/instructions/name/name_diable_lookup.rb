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
