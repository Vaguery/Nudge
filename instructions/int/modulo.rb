class IntModulo < NudgeInstruction
  get 2, :int
  
  def process
    if int(1) != 0
      put :int, int(0) % int(1)
    else
      # raise
    end
  end
end
