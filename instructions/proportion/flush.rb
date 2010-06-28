class ProportionFlush < NudgeInstruction
  def process
    @outcome_data.stacks[:proportion].clear
  end
end
