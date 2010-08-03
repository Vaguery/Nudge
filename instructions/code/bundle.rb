# encoding: UTF-8
class CodeBundle < NudgeInstruction
  get 1, :int
  
  def process
    return if int(0) < 0
    
    stacks = @executable.stacks
    code_depth = stacks[:code].length
    range = (code_depth - [int(0), code_depth].min)..-1
    
    put :code, ["block {", stacks[:code].slice!(range), "}"].join(" ")
  end
end
