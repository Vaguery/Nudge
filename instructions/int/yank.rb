# encoding: UTF-8
class IntYank < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:int].yank(int(0))
  end
end
