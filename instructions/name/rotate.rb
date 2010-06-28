class NameRotate < NudgeInstruction
  get 3, :name
  
  def process
    put :name, name(1)
    put :name, name(0)
    put :name, name(2)
  end
end
