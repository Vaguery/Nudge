class CodeFromProportion < NudgeInstruction
  get 1, :proportion
  
  def process
    put :code, ValuePoint.new(:proportion,proportion(0)).to_script
  end
end
