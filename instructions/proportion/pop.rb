class ProportionPop < NudgeInstruction
  def process
    @outcome_data.stacks[:proportion].pop
  end
end
