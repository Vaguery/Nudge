class ProportionFromInts < NudgeInstruction
  get 2, :int
  
  def process
    put :proportion, [[int(1).to_f/int(0),1.0].min,0.0].max
  end
end
