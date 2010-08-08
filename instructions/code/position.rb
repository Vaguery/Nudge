# encoding: UTF-8
class CodePosition < NudgeInstruction
  get 2, :code
  
  def process
    arg1 = NudgePoint.from(code(1))
    arg2 = NudgePoint.from(code(0))
    
    raise NudgeError::InvalidScript,"code_position" if arg1.is_a?(NilPoint) || arg2.is_a?(NilPoint)
    
    location = nil
    if arg1.is_a?(BlockPoint)
      pts = arg1.points
      (0...pts).each do |i|
        if arg1.get_point_at(i).to_script == arg2.to_script
          location = i
        end
        break if location
      end
    else
      location = 0 if arg1.to_script == arg2.to_script
    end
    
    raise NudgeError::NotFound,"code_position did not succeed" if location.nil?
    
    put :int, location
  end
end
