# encoding: UTF-8
class CodeFromBool < NudgeInstruction
  get 1, :bool
  
  def process
    put :code, "value «bool»\n«bool»#{bool(0)}"
  end
end
