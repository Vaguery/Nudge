class CodeRotateInstruction < Instruction
  include RotateInstruction
  def initialize(context)
    super(context, :code)
  end
end
