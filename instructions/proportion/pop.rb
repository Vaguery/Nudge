# encoding: UTF-8
class ProportionPop < NudgeInstruction
  def process
    @executable.stacks[:proportion].pop_string
  end
end
