# encoding: UTF-8
class ProportionRotate < NudgeInstruction
  get 3, :proportion
  
  def process
    put :proportion, proportion(1)
    put :proportion, proportion(0)
    put :proportion, proportion(2)
  end
end
