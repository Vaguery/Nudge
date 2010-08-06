# encoding: UTF-8
class RefPoint < NudgePoint
  def initialize (variable_name)
    @variable_name = variable_name
  end
  
  def evaluate (executable)
    if executable.lookup_allowed? && value = executable.variable_bindings[@variable_name]
      value.evaluate(executable)
    else
      executable.stacks[:name] << @variable_name
    end
  end
  
  def script_and_values
    "ref #{@variable_name}"
  end
end
