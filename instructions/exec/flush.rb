# encoding: UTF-8
class ExecFlush < NudgeInstruction
  def process
    @executable.stacks[:exec].clear
  end
end
