# encoding: UTF-8
class NamePop < NudgeInstruction
  def process
    @outcome_data.stacks[:name].pop
  end
end
