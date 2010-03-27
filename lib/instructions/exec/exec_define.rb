class ExecDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context)
    super(context, :exec)
  end
end
