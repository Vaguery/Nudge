# encoding: UTF-8
class NameDepth < NudgeInstruction
  def process
    put :int, @outcome_data.stacks[:name].length
  end
end
