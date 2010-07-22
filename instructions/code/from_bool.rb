class CodeFromBool < NudgeInstruction
  get 1, :bool
  
  def process
    put :code, ValuePoint.new(:bool,bool(0)).to_script
  end
end
