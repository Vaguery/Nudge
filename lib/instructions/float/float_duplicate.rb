class FloatDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :float)
  end
end
