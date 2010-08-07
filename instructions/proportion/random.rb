# encoding: UTF-8
class ProportionRandom < NudgeInstruction
  def process
    put :proportion, rand
  end
end
