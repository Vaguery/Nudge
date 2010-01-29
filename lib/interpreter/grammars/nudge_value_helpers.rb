# coding: utf-8
class ValuePoint < Treetop::Runtime::SyntaxNode
  attr_accessor :value
  
  def type=(new_type)
    @type = new_type
  end
  
  def type
    @type ||= footnote_type.text_value
  end
  
end
