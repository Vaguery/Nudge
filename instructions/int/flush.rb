# encoding: UTF-8
class IntFlush < NudgeInstruction
  def process
    @executable.stacks[:int].flush
  end
end
