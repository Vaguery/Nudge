class BoolRandom < NudgeInstruction
  def process
    put :bool, rand > 0.5
  end
end
