# encoding: UTF-8
class ProportionMultiply < NudgeInstruction
  get 2, :proportion
  
  def process
    put :proportion, proportion(0) * proportion(1)
  end
end
