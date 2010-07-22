class ProportionOfFloat < NudgeInstruction
  get 1, :proportion
  get 1, :float
  
  def process
    put :float, proportion(0)*float(0)
  end
end
