# encoding: UTF-8
class CodeDepth < NudgeInstruction
  def process
    put :int, @executable.stacks[:code].length
  end
end
