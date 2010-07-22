# encoding: UTF-8
class NameIf < NudgeInstruction
  get 1, :bool
  get 2, :name
  
  def process
    put :name, bool(0) ? name(1) : name(0)
  end
end
