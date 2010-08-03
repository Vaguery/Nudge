# encoding: UTF-8
class FloatDefine < NudgeInstruction
  get 1, :name
  get 1, :float
  
  def process
    @executable.variable_bindings[name(0)] = Value.new(:float, float(0))
  end
end
