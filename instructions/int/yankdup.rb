# encoding: UTF-8
class IntYankdup < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:int].yankdup(int(0))
  end
end
