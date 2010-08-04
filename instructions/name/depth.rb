# encoding: UTF-8
class NameDepth < NudgeInstruction
  def process
    put :int, @executable.stacks[:name].depth
  end
end
