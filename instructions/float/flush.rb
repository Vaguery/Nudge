# encoding: UTF-8
class FloatFlush < NudgeInstruction
  def process
    @executable.stacks[:float].flush
  end
end
