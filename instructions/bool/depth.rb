class BoolDepth < NudgeInstruction
  def process
    put :int, @outcome_data.stacks[:bool].length
  end
end
