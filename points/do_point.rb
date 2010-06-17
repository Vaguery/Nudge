class DoPoint < NudgePoint
  def initialize (instruction_id)
    @instruction_id = instruction_id
  end
  
  def evaluate (outcome_data)
    super
    Instruction.execute(@instruction_id, outcome_data)
  end
end
