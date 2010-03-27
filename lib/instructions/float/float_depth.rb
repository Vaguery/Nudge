class FloatDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :float)
  end
end
