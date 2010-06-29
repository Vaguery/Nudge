class FloatDivide < NudgeInstruction
  get 2, :float
  
  def process
    if float(1) != 0
      put :float, float(0) / float(1)
    else
      raise NudgeError::DivisionByZero, "cannot divide a float by 0"
    end
  end
end
