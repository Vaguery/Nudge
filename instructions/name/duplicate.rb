class NameDuplicate < NudgeInstruction
  get 1, :name
  
  def process
    put :name, name(0)
    put :name, name(0)
  end
end
