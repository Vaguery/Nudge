class CodeYankdupInstruction < Instruction
  include YankdupInstruction
  def initialize(context)
    super(context, :code)
  end
end
