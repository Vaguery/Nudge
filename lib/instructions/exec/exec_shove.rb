class ExecShoveInstruction < Instruction
  include ShoveInstruction
  def initialize(context)
    super(context, :exec)
  end
end
