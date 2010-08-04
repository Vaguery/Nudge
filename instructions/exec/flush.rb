# encoding: UTF-8
class ExecFlush < NudgeInstruction
  def process
    @executable.stacks[:exec].flush
  end
end
