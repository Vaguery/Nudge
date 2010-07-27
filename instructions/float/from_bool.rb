# encoding: UTF-8
class FloatFromBool < NudgeInstruction
  get 1, :bool
  
  def process
    put :float, bool(0) ? 1.0 : -1.0
  end
end
