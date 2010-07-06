class CodeAtomQ < NudgeInstruction
  get 1, :code
  
  def process
    put :bool, !NudgePoint.from(code(0)).kind_of?(BlockPoint)
  end
end
