class FloatDivide < NudgeInstruction
  get 2, :float
  
  def process
    if float(0) != 0
      put :float, float(1) / float(0)
    else
      raise NudgeError::DivisionByZero, "cannot divide a float by 0"
    end
  end
end
