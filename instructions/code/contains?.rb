# encoding: UTF-8
class CodeContainsQ < NudgeInstruction
  get 2, :code
  
  def process
    a = NudgePoint.from(code(1))
    b = NudgePoint.from(code(0))
    
    raise NudgeError::InvalidScript,
      "code_contains? cannot parse an argument" if a.is_a?(NilPoint) || b.is_a?(NilPoint)
    
    put :bool, a.to_script.include?(b.to_script)
  end
end
