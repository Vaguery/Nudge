# encoding: UTF-8
class BoolPop < NudgeInstruction
  def process
    @executable.stacks[:bool].pop_string
  end
end
