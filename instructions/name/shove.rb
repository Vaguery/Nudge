# encoding: UTF-8
class NameShove < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:name].shove(int(0))
  end
end
