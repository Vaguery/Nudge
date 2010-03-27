class NamePopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :name)
  end
end
