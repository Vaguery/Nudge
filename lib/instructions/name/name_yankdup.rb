class NameYankdupInstruction < Instruction
  include YankdupInstruction
  def initialize(context)
    super(context, :name)
  end
end
