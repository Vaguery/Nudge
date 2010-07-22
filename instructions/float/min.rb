# encoding: UTF-8
class FloatMin < NudgeInstruction
  get 2, :float
  
  def process
    put :float, [float(0), float(1)].min
  end
end
