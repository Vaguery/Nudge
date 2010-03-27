class IntShoveInstruction < Instruction
  include ShoveInstruction
  def initialize(context)
    super(context, :int)
  end
end
