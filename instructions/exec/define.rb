# encoding: UTF-8
class ExecDefine < NudgeInstruction
  get 1, :name
  get 1, :exec
  
  def process
    @outcome_data.variable_bindings[name(0)] = ValuePoint.new(:exec, exec(0))
  end
end
