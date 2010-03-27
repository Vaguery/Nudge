class FloatYankInstruction < Instruction
  include YankInstruction
  def initialize(context)
    super(context, :float)
  end
end
