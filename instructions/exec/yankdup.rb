# encoding: UTF-8
class ExecYankdup < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:exec].yankdup(int(0))
  end
end
