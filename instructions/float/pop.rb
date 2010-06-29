class FloatPop < NudgeInstruction
  def process
    @outcome_data.stacks[:float].pop
  end
end
