# encoding: UTF-8
class BoolDepth < NudgeInstruction
  def process
    put :int, @executable.stacks[:bool].length
  end
end
