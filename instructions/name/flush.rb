# encoding: UTF-8
class NameFlush < NudgeInstruction
  def process
    @outcome_data.stacks[:name].clear
  end
end
