class CodePopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :code)
  end
end
