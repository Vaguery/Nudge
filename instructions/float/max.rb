# encoding: UTF-8
class FloatMax < NudgeInstruction
  get 2, :float
  
  def process
    put :float, [float(0), float(1)].max
  end
end
