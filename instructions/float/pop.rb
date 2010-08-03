# encoding: UTF-8
class FloatPop < NudgeInstruction
  def process
    @executable.stacks[:float].pop_string
  end
end
