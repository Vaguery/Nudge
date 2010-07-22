# encoding: UTF-8
class NameEqualQ < NudgeInstruction
  get 2, :name
  
  def process
    put :bool, name(0) == name(1)
  end
end
