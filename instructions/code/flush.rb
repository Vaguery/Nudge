# encoding: UTF-8
class CodeFlush < NudgeInstruction
  def process
    @executable.stacks[:code].flush
  end
end
