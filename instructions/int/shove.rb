# encoding: UTF-8
class IntShove < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:int].shove(int(0))
  end
end
