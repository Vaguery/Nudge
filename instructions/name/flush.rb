# encoding: UTF-8
class NameFlush < NudgeInstruction
  def process
    @executable.stacks[:name].clear
  end
end
