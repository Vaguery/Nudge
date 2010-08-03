# encoding: UTF-8
class IntPop < NudgeInstruction
  def process
    @executable.stacks[:int].pop_string
  end
end
