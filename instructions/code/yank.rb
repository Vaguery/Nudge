# encoding: UTF-8
class CodeYank < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:code].yank(int(0))
  end
end
