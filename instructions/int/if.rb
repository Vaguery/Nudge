# encoding: UTF-8
class IntIf < NudgeInstruction
  get 1, :bool
  get 2, :int
  
  def process
    put :int, bool(0) ? int(1) : int(0)
  end
end
