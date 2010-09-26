# encoding: UTF-8
class BoolToffoli < NudgeInstruction
  get 3, :bool
  
  def process
    put :bool, bool(2)
    put :bool, bool(1)
    put :bool, bool(0) != (bool(2) && bool(1))
  end
end
