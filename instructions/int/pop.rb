# encoding: UTF-8
class IntPop < NudgeInstruction
  def process
    @outcome_data.stacks[:int].pop
  end
end
