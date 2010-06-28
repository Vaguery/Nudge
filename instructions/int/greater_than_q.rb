class IntGreaterThanQ < NudgeInstruction
  get 2, :int
  
  def process
    put :int, int(0) > int(1)
  end
end
