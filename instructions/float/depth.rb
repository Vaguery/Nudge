# encoding: UTF-8
class FloatDepth < NudgeInstruction
  def process
    put :int, @outcome_data.stacks[:float].length
  end
end
