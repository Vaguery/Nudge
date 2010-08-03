# encoding: UTF-8
class NameYank < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:name].yank(int(0))
  end
end
