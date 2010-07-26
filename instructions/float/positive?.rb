# encoding: UTF-8
class FloatPositiveQ < NudgeInstruction
  get 1, :float
  
  def process
    put :bool, float(0) > 0.0
  end
end
