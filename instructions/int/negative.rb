class IntNegative < NudgeInstruction
  get 1, :int
  
  def process
    put :int, -int(0)
  end
end
