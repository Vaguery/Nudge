# encoding: UTF-8
class CodeContainsQ < NudgeInstruction
  get 2, :code
  
  def process
    arg1 = NudgePoint.from(code(1))
    arg2 = NudgePoint.from(code(0))
    
    raise NudgeError::InvalidScript,
      "code_contains? cannot parse an argument" if arg1.is_a?(NilPoint) || arg2.is_a?(NilPoint)
    result = arg1.is_a?(BlockPoint) ? tree_match(arg1, arg2, false) : false
    put :bool, result
  end
  
  
  def tree_match(item_being_checked, target, found=false)
    found ||= (item_being_checked.to_script == target.to_script)
    if item_being_checked.is_a?(BlockPoint)
      item_being_checked.instance_variable_get(:@points).each do |pt|
        found ||= tree_match(pt, target, found) 
      end
    end
    return found
  end
end
