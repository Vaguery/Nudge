# encoding: UTF-8
class ExecDepth < NudgeInstruction
  def process
    put :int, @executable.stacks[:exec].depth
  end
end
