# encoding: UTF-8
class BoolPop < NudgeInstruction
  def process
    @outcome_data.stacks[:bool].pop
  end
end
