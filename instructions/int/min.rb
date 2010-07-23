# encoding: UTF-8
class IntMin < NudgeInstruction
  get 2, :int
  
  def process
    put :int, [int(0), int(1)].min
  end
end
