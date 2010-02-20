# coding: utf-8
class InstructionParseNode < Treetop::Runtime::SyntaxNode
  def instruction_name
    opcode.text_value
  end
  
  def tidy(level=1)
    "do #{instruction_name}"
  end
  
  def to_point
    InstructionPoint.new(instruction_name)
  end
end
