# encoding: UTF-8
class FloatRotate < NudgeInstruction
  get 3, :float
  
  def process
    put :float, float(1)
    put :float, float(0)
    put :float, float(2)
  end
end
