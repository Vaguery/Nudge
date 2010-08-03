# encoding: UTF-8
class ProportionDepth < NudgeInstruction
  def process
    put :int, @executable.stacks[:proportion].length
  end
end
