# encoding: UTF-8
class ProportionFlush < NudgeInstruction
  def process
    @executable.stacks[:proportion].flush
  end
end
