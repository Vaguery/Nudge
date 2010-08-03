# encoding: UTF-8
class ProportionYank < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:proportion].yank(int(0))
  end
end
