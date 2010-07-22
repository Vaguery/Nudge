# encoding: UTF-8
class FloatMultiply < NudgeInstruction
  get 2, :float
  
  def process
    put :float, float(0) * float(1)
  end
end
