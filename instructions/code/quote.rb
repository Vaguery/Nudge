# encoding: UTF-8
class CodeQuote < NudgeInstruction
  get 1, :exec
  
  def process
    put :code, exec(0).to_script
  end
end
