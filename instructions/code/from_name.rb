# encoding: UTF-8
class CodeFromName < NudgeInstruction
  get 1, :name
  
  def process
    put :code, "ref #{name(0)}"
  end
end
