class CodeFromFloat < NudgeInstruction
  get 1, :float
  
  def process
    put :code, ValuePoint.new(:float,float(0)).to_script
  end
end
