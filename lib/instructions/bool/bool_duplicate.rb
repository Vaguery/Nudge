class BoolDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :bool)
  end
end
