# coding: utf-8
class ReferenceProgramPoint < Treetop::Runtime::SyntaxNode
  def variable_name
    vname.text_value
  end
end
