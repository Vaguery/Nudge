class CodeAtomQ < NudgeInstruction
  get 1, :code
  
  def process
    put :bool, ![BlockPoint,NilPoint].include?(NudgePoint.from(code(0)).class)
  end
end
