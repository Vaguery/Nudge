class NameDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :name)
  end
end
