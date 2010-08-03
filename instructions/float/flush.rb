# encoding: UTF-8
class FloatFlush < NudgeInstruction
  def process
    @executable.stacks[:float].clear
  end
end
