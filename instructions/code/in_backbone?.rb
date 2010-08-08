# encoding: UTF-8
class CodeInBackboneQ < NudgeInstruction
  get 2, :code
  
  def process
    arg1 = NudgePoint.from(code(1))
    arg2 = NudgePoint.from(code(0))
    
    if arg1.is_a?(NilPoint) || arg2.is_a?(NilPoint)
      raise NudgeError::InvalidScript, "code_in_backbone? can't parse an argument"
    end
    
    result = false
    
    if arg1.is_a?(BlockPoint)
      match_string = arg2.to_script
      arg1.instance_variable_get(:@points).each do |pt|
        result = true if pt.to_script == match_string
      end
    end
    
    put :bool, result
  end
end
