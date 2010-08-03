# encoding: UTF-8
class FloatYankdup < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:float].yankdup(int(0))
  end
end
