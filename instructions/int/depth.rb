# encoding: UTF-8
class IntDepth < NudgeInstruction
  def process
    put :int, @outcome_data.stacks[:int].length
  end
end
