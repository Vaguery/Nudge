class IntIfInstruction < Instruction
  
  include IfInstruction
  
  def initialize(context)
    super(context, :int)
  end
end
