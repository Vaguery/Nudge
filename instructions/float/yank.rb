# encoding: UTF-8
class FloatYank < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:float].yank(int(0))
  end
end
