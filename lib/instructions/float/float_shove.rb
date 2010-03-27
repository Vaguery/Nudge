class FloatShoveInstruction < Instruction
  include ShoveInstruction
  def initialize(context)
    super(context, :float)
  end
end
