# encoding: UTF-8
class FloatShove < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:float].shove(int(0))
  end
end
