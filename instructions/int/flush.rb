class IntFlush < NudgeInstruction
  def process
    @outcome_data.stacks[:int].clear
  end
end
