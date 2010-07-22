# encoding: UTF-8
class FloatIf < NudgeInstruction
  get 1, :bool
  get 2, :float
  
  def process
    put :float, bool(0) ? float(1) : float(0)
  end
end
