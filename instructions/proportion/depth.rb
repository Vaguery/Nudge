class ProportionDepth < NudgeInstruction
  def process
    put :int, @outcome_data.stacks[:proportion].length
  end
end
