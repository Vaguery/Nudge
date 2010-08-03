# encoding: UTF-8
class NamePop < NudgeInstruction
  def process
    @executable.stacks[:name].pop_string
  end
end
