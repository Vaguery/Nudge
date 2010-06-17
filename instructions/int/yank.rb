class Instruction::IntYank < Instruction
  get 1, :int
  
  def process
    stack = @outcome_data.stacks[:int]
    return if stack.length < 2
    
    position = int(0)
    
    case
      when position <= 0
      when position >= stack.length then stack.push(stack.shift)
      else stack.push(stack.delete_at(stack.length - 1 - position))
    end
  end
end
