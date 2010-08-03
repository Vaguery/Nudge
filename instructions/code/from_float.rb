# encoding: UTF-8
class CodeFromFloat < NudgeInstruction
  get 1, :float
  
  def process
    put :code, "value «float»\n«float»#{float(0)}"
  end
end
