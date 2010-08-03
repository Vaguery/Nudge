# encoding: UTF-8
class ExecPop < NudgeInstruction
  def process
    @executable.stacks[:exec].pop_value
  end
end
