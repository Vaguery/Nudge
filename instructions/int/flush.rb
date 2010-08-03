# encoding: UTF-8
class IntFlush < NudgeInstruction
  def process
    @executable.stacks[:int].clear
  end
end
