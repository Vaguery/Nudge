class FloatFromInt < NudgeInstruction
  get 1, :int
  
  def process
    put :float, int(0).to_f
  end
end
