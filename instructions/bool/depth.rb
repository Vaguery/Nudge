# encoding: UTF-8
class BoolDepth < NudgeInstruction
  def process
    put :int, @executable.stacks[:bool].depth
  end
end
