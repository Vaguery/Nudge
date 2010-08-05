# encoding: UTF-8
class FloatNegative < NudgeInstruction
  get 1, :float
  
  def process
    put :float, -float(0)
  end
end
