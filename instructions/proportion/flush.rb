# encoding: UTF-8
class ProportionFlush < NudgeInstruction
  def process
    @outcome_data.stacks[:proportion].clear
  end
end
