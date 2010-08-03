# encoding: UTF-8
class CodePop < NudgeInstruction
  def process
    @executable.stacks[:code].pop_string
  end
end
