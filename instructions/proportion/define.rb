# encoding: UTF-8
class ProportionDefine < NudgeInstruction
  get 1, :name
  get 1, :proportion
  
  def process
    @executable.variable_bindings[name(0)] = Value.new(:proportion, proportion(0))
  end
end
