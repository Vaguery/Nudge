# encoding: UTF-8
class ProportionDuplicate < NudgeInstruction
  get 1, :proportion
  
  def process
    put :proportion, proportion(0)
    put :proportion, proportion(0)
  end
end
