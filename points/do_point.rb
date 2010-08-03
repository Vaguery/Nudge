# encoding: UTF-8
class DoPoint < NudgePoint
  def initialize (instruction_name)
    @instruction_name = instruction_name
  end
  
  def evaluate (executable)
    NudgeInstruction.execute(@instruction_name, executable)
  end
  
  def script_and_values
    "do #{@instruction_name}"
  end
end
