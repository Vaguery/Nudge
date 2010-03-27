class CodeDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :code)
  end
end
