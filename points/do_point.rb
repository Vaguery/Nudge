class DoPoint < NudgePoint
  def initialize (instruction_name)
    @instruction_name = instruction_name
  end
  
  def evaluate (outcome_data)
    super
    Instruction.execute(@instruction_name, outcome_data)
  end
  
  def script_and_values
    return "do #{@instruction_name}", []
  end
end
