class CodeRotate < NudgeInstruction
  get 3, :code
  
  def process
    put :code, code(1)
    put :code, code(0)
    put :code, code(2)
  end
end
