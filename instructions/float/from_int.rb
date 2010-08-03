# encoding: UTF-8
class FloatFromInt < NudgeInstruction
  get 1, :int
  
  def process
    result = int(0).to_f
    
    raise NudgeError::NaN, "result of float_from_int was infinity" if result.infinite?
    
    put :float, result
  end
end
