class CodeEqualQ < NudgeInstruction
  get 2, :code
  
  def process
    put :bool, NudgePoint.from(code(0)).to_script == NudgePoint.from(code(1)).to_script
  end
end
