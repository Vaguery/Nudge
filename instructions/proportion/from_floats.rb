class ProportionFromFloats < NudgeInstruction
  get 2, :float
  
  def process
    put :proportion, [[float(1)/float(0),1.0].min,0.0].max
  end
end
