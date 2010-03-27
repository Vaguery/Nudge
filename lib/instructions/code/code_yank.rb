class CodeYankInstruction < Instruction
  include YankInstruction
  def initialize(context)
    super(context, :code)
  end
end
