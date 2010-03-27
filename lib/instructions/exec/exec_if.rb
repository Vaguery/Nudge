class ExecIfInstruction < Instruction
  
  include IfInstruction
  
  def initialize(context)
    super(context, :exec)
  end
end
