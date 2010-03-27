class BoolDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :bool)
  end
end
