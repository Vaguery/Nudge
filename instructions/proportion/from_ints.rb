# encoding: UTF-8
class ProportionFromInts < NudgeInstruction
  get 2, :int
  
  def process
    raise NudgeError::NaN, "proportion_from_ints divided by zero" if int(0) == 0
    
    put :proportion, [0.0, [int(1).to_f / int(0), 1.0].min].max
  end
end
