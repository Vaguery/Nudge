# encoding: UTF-8
class ProportionYankdup < NudgeInstruction
  get 1, :int
  
  def process
    @executable.stacks[:proportion].yankdup(int(0))
  end
end
