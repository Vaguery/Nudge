# encoding: UTF-8
class BoolDuplicate < NudgeInstruction
  get 1, :bool
  
  def process
    put :bool, bool(0)
    put :bool, bool(0)
  end
end
