class IntSwap < NudgeInstruction
  get 2, :int
  
  def process
    put :int, int(0)
    put :int, int(1)
  end
end
