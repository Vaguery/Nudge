class RefPoint < NudgePoint
  def initialize (variable_name)
    @variable_name = variable_name
  end
  
  def evaluate (outcome_data)
    super
    
    if value = outcome_data.variable_bindings[@variable_name]
      value.evaluate(outcome_data)
    end
  end
  
  def script_and_values
    return "ref #{@variable_name}", []
  end
end
