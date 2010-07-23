# encoding: UTF-8
class ProportionSwap < NudgeInstruction
  get 2, :proportion
  
  def process
    put :proportion, proportion(0)
    put :proportion, proportion(1)
  end
end
