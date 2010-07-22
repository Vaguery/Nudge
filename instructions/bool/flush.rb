# encoding: UTF-8
class BoolFlush < NudgeInstruction
  def process
    @outcome_data.stacks[:bool].clear
  end
end
