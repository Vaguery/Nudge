# encoding: UTF-8
class ExecShove < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:exec].shove(int(0))
  end
end
