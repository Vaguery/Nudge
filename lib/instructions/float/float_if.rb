class FloatIfInstruction < Instruction
  
  include IfInstruction
  
  def initialize(context)
    super(context, :float)
  end
end
