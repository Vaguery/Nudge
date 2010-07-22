class CodeFromInt < NudgeInstruction
  get 1, :int
  
  def process
    put :code, ValuePoint.new(:int,int(0)).to_script
  end
end
