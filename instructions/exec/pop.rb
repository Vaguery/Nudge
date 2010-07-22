# encoding: UTF-8
class ExecPop < NudgeInstruction
  def process
    @outcome_data.stacks[:exec].pop
  end
end
