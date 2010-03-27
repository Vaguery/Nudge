class NameDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :name)
  end
end
