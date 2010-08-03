# encoding: UTF-8
class ExecYank < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:exec].yank(int(0))
  end
end
