# encoding: UTF-8
class CodeEqualQ < NudgeInstruction
  get 2, :code
  
  def process
    a = NudgePoint.from(code(0))
    b = NudgePoint.from(code(1))
    
    put :bool, a.to_script == b.to_script
  end
end
