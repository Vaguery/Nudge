class FloatPowerInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @exp =  @context.pop_value(:float)
    @base = @context.pop_value(:float)
  end
  def derive
    if !(@base**@exp).nan?
      @result = ValuePoint.new("float", @base**@exp)
    else
      raise Instruction::NaNResultError, "#{self.class.to_nudgecode} did not return a float"
    end
    
  end
  def cleanup
    pushes :float, @result
  end
end
