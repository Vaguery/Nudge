# encoding: UTF-8
class FloatTangent < NudgeInstruction
  get 1, :float
  
  def process
    put :float, Math.tan(float(0))
  end
end
