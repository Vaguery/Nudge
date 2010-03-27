class BoolYankInstruction < Instruction
  include YankInstruction
  def initialize(context)
    super(context, :bool)
  end
end
