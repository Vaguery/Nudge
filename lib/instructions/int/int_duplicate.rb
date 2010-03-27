class IntDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :int)
  end
end
