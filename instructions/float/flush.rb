class FloatFlush < NudgeInstruction
  def process
    @outcome_data.stacks[:float].clear
  end
end
