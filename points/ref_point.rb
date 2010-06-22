class RefPoint < NudgePoint
  def initialize (variable_id)
    @variable_id = variable_id
  end
  
  def evaluate (outcome_data)
    super
    
    if value = outcome_data.variable_bindings[@variable_id]
      value.evaluate(outcome_data)
    end
  end
  
  def script_and_values
    return "ref #{@variable_id}", []
  end
end
