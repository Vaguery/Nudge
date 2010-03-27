class NameYankInstruction < Instruction
  include YankInstruction
  def initialize(context)
    super(context, :name)
  end
end
