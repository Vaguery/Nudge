class BoolShoveInstruction < Instruction
  include ShoveInstruction
  def initialize(context)
    super(context, :bool)
  end
end
