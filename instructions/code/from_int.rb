# encoding: UTF-8
class CodeFromInt < NudgeInstruction
  get 1, :int
  
  def process
    put :code, "value «int»\n«int»#{int(0)}"
  end
end
