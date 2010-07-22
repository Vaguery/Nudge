# encoding: UTF-8
class FloatNegative < NudgeInstruction
  get 2, :float
  
  def process
    put :float, -float(0)
  end
end
