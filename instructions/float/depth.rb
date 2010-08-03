# encoding: UTF-8
class FloatDepth < NudgeInstruction
  def process
    put :int, @executable.stacks[:float].length
  end
end
