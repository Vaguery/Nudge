# encoding: UTF-8
class BoolFlush < NudgeInstruction
  def process
    @executable.stacks[:bool].flush
  end
end
