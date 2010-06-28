class BoolRotate < NudgeInstruction
  get 3, :bool
  
  def process
    put :bool, bool(1)
    put :bool, bool(0)
    put :bool, bool(2)
  end
end
