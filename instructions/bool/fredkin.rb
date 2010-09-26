# encoding: UTF-8
class BoolFredkin < NudgeInstruction
  get 3, :bool
  
  def process
    put :bool, bool(2)
    put :bool, bool(2) ? bool(0) : bool(1)
    put :bool, bool(2) ? bool(1) : bool(0)
  end
end
