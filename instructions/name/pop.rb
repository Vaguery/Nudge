class NamePop < NudgeInstruction
  def process
    @outcome_data.stacks[:name].pop
  end
end
