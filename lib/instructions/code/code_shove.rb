class CodeShoveInstruction < Instruction
  include ShoveInstruction
  def initialize(context)
    super(context, :code)
  end
end
