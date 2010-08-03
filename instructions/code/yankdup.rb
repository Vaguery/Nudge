# encoding: UTF-8
class CodeYankdup < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:code].yankdup(int(0))
  end
end
