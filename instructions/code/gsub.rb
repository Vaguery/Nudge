# encoding: UTF-8
class CodeGsub < NudgeInstruction
  get 3, :code
  
  def process
    arg1 = NudgePoint.from(code(2))
    arg2 = NudgePoint.from(code(1))
    arg3 = NudgePoint.from(code(0))
    
    if arg1.is_a?(NilPoint) || arg2.is_a?(NilPoint) || arg3.is_a?(NilPoint)
      raise NudgeError::InvalidScript,"code_gsub"
    end
    
    match_points(arg1, arg2).each {|target| arg1.replace_point_at(target, arg3)}
    put :code, arg1.to_script
  end
  
  
  def match_points(context, target)
    sought_string = target.to_script
    found = []
    
    (0..context.points-1).each do |i|
      found << i if context.get_point_at(i).to_script == sought_string
    end 
    found.reverse
  end
end
