# encoding: UTF-8
class ProportionRandom < NudgeInstruction
  def process
    put :proportion, Kernel.rand
  end
end
