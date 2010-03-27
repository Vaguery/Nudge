class ExecDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :exec)
  end
end
