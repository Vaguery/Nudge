# encoding: UTF-8
class FloatSubtract < NudgeInstruction
  get 2, :float
  
  def process
    put :float, float(1) - float(0)
  end
end
