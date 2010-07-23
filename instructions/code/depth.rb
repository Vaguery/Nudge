# encoding: UTF-8
class CodeDepth < NudgeInstruction
  def process
    put :int, @outcome_data.stacks[:code].length
  end
end
