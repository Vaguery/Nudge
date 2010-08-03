# encoding: UTF-8
class CodeFromProportion < NudgeInstruction
  get 1, :proportion
  
  def process
    put :code, "value «proportion»\n«proportion»#{proportion(0)}"
  end
end
