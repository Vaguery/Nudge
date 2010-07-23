# encoding: UTF-8
class IntRotate < NudgeInstruction
  get 3, :int
  
  def process
    put :int, int(1)
    put :int, int(0)
    put :int, int(2)
  end
end
