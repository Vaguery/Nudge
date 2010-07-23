# encoding: UTF-8
class IntSubtract < NudgeInstruction
  get 2, :int
  
  def process
    put :int, int(1) - int(0)
  end
end
