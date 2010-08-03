# encoding: UTF-8
class BoolFlush < NudgeInstruction
  def process
    @executable.stacks[:bool].clear
  end
end
