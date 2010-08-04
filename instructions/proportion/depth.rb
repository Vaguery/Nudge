# encoding: UTF-8
class ProportionDepth < NudgeInstruction
  def process
    put :int, @executable.stacks[:proportion].depth
  end
end
