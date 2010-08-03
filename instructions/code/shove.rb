# encoding: UTF-8
class CodeShove < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:code].shove(int(0))
  end
end
