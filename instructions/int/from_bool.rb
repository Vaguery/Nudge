# encoding: UTF-8
class IntFromBool < NudgeInstruction
  get 1, :bool
  
  def process
    put :int, bool(0) ? 1 : -1
  end
end
