# coding: utf-8
class ReferencePoint < Treetop::Runtime::SyntaxNode
  def variable_name
    vname.text_value
  end
end
