class IntYankInstruction < Instruction
  include YankInstruction
  def initialize(context)
    super(context, :int)
  end
end
