# encoding: UTF-8
class CodePop < NudgeInstruction
  def process
    @outcome_data.stacks[:code].pop
  end
end
