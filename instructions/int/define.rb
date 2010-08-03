# encoding: UTF-8
class IntDefine < NudgeInstruction
  get 1, :name
  get 1, :int
  
  def process
    @executable.variable_bindings[name(0)] = Value.new(:int, int(0))
  end
end
