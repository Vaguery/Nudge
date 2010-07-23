# encoding: UTF-8
class FloatAbs < NudgeInstruction
  get 1, :float
  
  def process
    put :float, float(0).abs
  end
end
