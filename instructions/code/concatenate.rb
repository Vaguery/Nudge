# encoding: UTF-8
class CodeConcatenate < NudgeInstruction
  get 2, :code
  
  def process
    a = NudgePoint.from(code(1))
    b = NudgePoint.from(code(0))
    
    raise NudgeError::InvalidScript,
      "code_concatenate cannot parse an argument" if a.is_a?(NilPoint) || b.is_a?(NilPoint)
    
    a_points = a.instance_variable_get(:@points)
    b_points = b.instance_variable_get(:@points)
    
    if a_points && b_points
      a_points.concat b_points
    elsif a_points
      a_points << b
    elsif b_points
      a = BlockPoint.new(a, *b_points)
    else
      a = BlockPoint.new(a, b)
    end
    
    put :code, a.to_script
  end
end
