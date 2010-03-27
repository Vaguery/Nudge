class FloatDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context)
    super(context, :float)
  end
end
