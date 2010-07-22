# encoding: UTF-8
class CodeFlush < NudgeInstruction
  def process
    @outcome_data.stacks[:code].clear
  end
end
