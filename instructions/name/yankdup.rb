# encoding: UTF-8
class NameYankdup < NudgeInstruction
  get 1, :int
  
  def process
    stack = @outcome_data.stacks[:name]
    return if stack.length < 2
    
    position = int(0)
    
    case
      when position <= 0 then stack.push(stack.last)
      when position >= stack.length then stack.push(stack.first)
      else stack.push(stack[stack.length - 1 - position])
    end
  end
end
