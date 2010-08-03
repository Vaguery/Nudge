# encoding: UTF-8
class BoolYank < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:bool].yank(int(0))
  end
end
