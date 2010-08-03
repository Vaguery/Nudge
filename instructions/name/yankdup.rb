# encoding: UTF-8
class NameYankdup < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:name].yankdup(int(0))
  end
end
