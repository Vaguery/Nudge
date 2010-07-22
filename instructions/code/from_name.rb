class CodeFromName < NudgeInstruction
  get 1, :name
  
  def process
    put :code, RefPoint.new(name(0)).to_script
  end
end
