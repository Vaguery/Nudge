# encoding: UTF-8
class ProportionMin < NudgeInstruction
  get 2, :proportion
  
  def process
    put :proportion, [proportion(0), proportion(1)].min
  end
end
