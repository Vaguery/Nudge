class CodeContainsQ < NudgeInstruction
  get 2, :code
  
  def process
    arg1 = NudgePoint.from(code(1)).to_script
    arg2 = NudgePoint.from(code(0)).to_script
    put :bool, arg1.include?(arg2)
  end
end
