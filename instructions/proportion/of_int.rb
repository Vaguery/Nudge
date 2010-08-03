# encoding: UTF-8
class ProportionOfInt < NudgeInstruction
  get 1, :proportion
  get 1, :int
  
  def process
    result = proportion(0) * int(0)
    
    raise NudgeError::NaN, "result of proportion_of_int was infinity" if result.infinite?
    
    put :int, result.round
  end
end
