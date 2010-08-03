# encoding: UTF-8
class CodeExecuteThenPop < NudgeInstruction
  get 1, :code
  
  def process
    point = NudgePoint.from(code(0))
    code_pop = DoPoint.new(:code_pop)
    
    put :exec, BlockPoint.new(point, code_pop)
    put :code, code(0)
  end
end
