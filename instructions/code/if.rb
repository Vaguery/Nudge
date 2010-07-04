class CodeIf < NudgeInstruction
  get 1, :bool
  get 2, :code
  
  def process
    put :code, bool(0) ? code(1) : code(0)
  end
end
