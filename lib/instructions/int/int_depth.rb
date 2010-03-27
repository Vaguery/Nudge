class IntDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :int)
  end
end
