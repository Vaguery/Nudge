class IntLessThanQ < NudgeInstruction
  get 2, :int
  
  def process
    put :bool, int(1) < int(0)
  end
end
