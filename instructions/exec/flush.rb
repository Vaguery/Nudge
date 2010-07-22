# encoding: UTF-8
class ExecFlush < NudgeInstruction
  def process
    @outcome_data.stacks[:exec].clear
  end
end
