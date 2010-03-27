class IntDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context)
    super(context, :int)
  end
end
