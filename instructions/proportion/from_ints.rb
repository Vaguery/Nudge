# encoding: UTF-8
class ProportionFromInts < NudgeInstruction
  get 2, :int
  
  def process
    put :proportion, [0.0, [int(1).to_f / int(0), 1.0].min].max
  end
end
