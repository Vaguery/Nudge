# encoding: UTF-8
class CodeCons < NudgeInstruction
  get 2, :code
  
  def process
    a = NudgePoint.from(code(1))
    b = NudgePoint.from(code(0))
    
    raise NudgeError::InvalidScript,
      "code_cons cannot parse an argument" if a.is_a?(NilPoint) || b.is_a?(NilPoint)
    
    if b.is_a?(BlockPoint)
      b.insert_point_before(1, a)
    else
      b = BlockPoint.new(a, b)
    end
    
    put :code, b.to_script
  end
end
