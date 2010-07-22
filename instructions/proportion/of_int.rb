class ProportionOfInt < NudgeInstruction
  get 1, :proportion
  get 1, :int
  
  def process
    put :int, (proportion(0)*int(0)).round
  end
end
