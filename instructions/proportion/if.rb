# encoding: UTF-8
class ProportionIf < NudgeInstruction
  get 1, :bool
  get 2, :proportion
  
  def process
    put :proportion, bool(0) ? proportion(1) : proportion(0)
  end
end
