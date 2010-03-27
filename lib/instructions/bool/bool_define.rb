class BoolDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context)
    super(context, :bool)
  end
end
