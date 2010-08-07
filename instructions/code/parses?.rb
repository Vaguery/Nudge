# encoding: UTF-8
class CodeParsesQ < NudgeInstruction
  get 1, :code
  
  def process
    put :bool, !NudgePoint.from(code(0)).is_a?(NilPoint)
  end
end
