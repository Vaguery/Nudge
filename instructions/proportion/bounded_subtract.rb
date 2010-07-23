# encoding: UTF-8
class ProportionBoundedSubtract < NudgeInstruction
  get 2, :proportion
  
  def process
    put :proportion, [proportion(1) - proportion(0), 0.0].max
  end
end
