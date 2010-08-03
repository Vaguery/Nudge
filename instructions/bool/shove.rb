# encoding: UTF-8
class BoolShove < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:bool].shove(int(0))
  end
end
