class BoolPop < NudgeInstruction
  def process
    @outcome_data.stacks[:bool].pop
  end
end
