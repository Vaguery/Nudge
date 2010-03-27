class CodeDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :code)
  end
end
