# coding: utf-8
class InstructionProgramPoint < Treetop::Runtime::SyntaxNode
  def instruction_name
    opcode.text_value
  end
end
