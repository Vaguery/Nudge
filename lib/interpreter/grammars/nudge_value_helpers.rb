# coding: utf-8
class ValueParseNode < Treetop::Runtime::SyntaxNode
  def type=(new_type)
    @type = new_type
  end
  
  def type
    @type ||= footnote_type.text_value
  end
  
  def tidy(level=1)
    "value «#{type}»"
  end
  
  def to_point
    return ValuePoint.new(type)
  end
  
end
