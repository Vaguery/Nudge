class FloatSqrtInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = @context.pop_value(:float)
  end
  def derive
    if @arg1 >= 0.0
      @result = ValuePoint.new("float", Math.sqrt(@arg1))
    else
      raise Instruction::NaNResultError, "#{self.class.to_nudgecode} did not return a float"
    end
  end
  def cleanup
    pushes :float, @result
  end
end
