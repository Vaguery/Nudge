# encoding: UTF-8
class IntDepth < NudgeInstruction
  def process
    put :int, @executable.stacks[:int].depth
  end
end
