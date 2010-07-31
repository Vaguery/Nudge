# encoding: UTF-8
class CodeDefine < NudgeInstruction
  get 1, :name
  get 1, :code
  
  def process
    @outcome_data.variable_bindings[name(0)] = Value.new(:code, code(0))
  end
end
