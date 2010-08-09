# encoding: UTF-8
class CodeContainer < NudgeInstruction
  get 2, :code
  
  def process
    arg1 = NudgePoint.from(code(1))
    arg2 = NudgePoint.from(code(0))
    
    raise NudgeError::InvalidScript,
      "code_container cannot parse an argument" if arg1.is_a?(NilPoint) || arg2.is_a?(NilPoint)
      
    raise NudgeError::InvalidIndex,
      "code_container called on a non-block item" unless arg1.is_a?(BlockPoint)
    
    result = tree_container(arg1, arg2)
    
    put :code, result.nil? ? "block {}" : result.to_script
  end
  
  
  def tree_container(item_being_checked, target)
    if item_being_checked.is_a?(BlockPoint)
      item_being_checked.instance_variable_get(:@points).each do |pt|
        if pt.to_script == target.to_script
          return item_being_checked
        else
          if pt.is_a?(BlockPoint)
            return tree_container(pt, target)
          end
        end
      end
      return nil
    end
  end
  
end
