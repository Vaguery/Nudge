# encoding: UTF-8
class ProportionFromFloats < NudgeInstruction
  get 2, :float
  
  def process
    raise NudgeError::NaN, "proportion_from_floats divided by zero" if float(0) == 0
    
    put :proportion, [0.0, [float(1) / float(0), 1.0].min].max
  end
end
