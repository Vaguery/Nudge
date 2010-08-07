# encoding: UTF-8
class BoolRandom < NudgeInstruction
  def process
    put :bool, Kernel.rand > 0.5
  end
end
