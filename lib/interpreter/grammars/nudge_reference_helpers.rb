# coding: utf-8
class ReferenceParseNode < Treetop::Runtime::SyntaxNode
  def variable_name
    vname.text_value
  end
  
  def tidy(level=1)
    "ref #{variable_name}"
  end
  
  def to_point
    ReferencePoint.new(variable_name)
  end
end
