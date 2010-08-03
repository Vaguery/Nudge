# encoding: UTF-8
class ProportionShove < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:proportion].shove(int(0))
  end
end
