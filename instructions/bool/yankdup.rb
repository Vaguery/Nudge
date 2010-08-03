# encoding: UTF-8
class BoolYankdup < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:bool].yankdup(int(0))
  end
end
