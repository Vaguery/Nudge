class NameShoveInstruction < Instruction
  include ShoveInstruction
  def initialize(context)
    super(context, :name)
  end
end
