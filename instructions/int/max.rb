# encoding: UTF-8
class IntMax < NudgeInstruction
  get 2, :int
  
  def process
    put :int, [int(0), int(1)].max
  end
end
