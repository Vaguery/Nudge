# encoding: UTF-8
class ExecDepth < NudgeInstruction
  def process
    put :int, @outcome_data.stacks[:exec].length
  end
end
