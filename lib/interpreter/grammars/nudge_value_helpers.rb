# coding: utf-8
class ValueProgramPoint < Treetop::Runtime::SyntaxNode
  attr_accessor :associated_value
  
  def type=(new_type)
    @type = new_type
  end
  
  def type
    @type ||= footnote_type.text_value
  end
  
  def initialize(*args)
    if $GIANT_GLOBAL_KLUDGE && $GIANT_GLOBAL_KLUDGE.length > 0
      @associated_value = $GIANT_GLOBAL_KLUDGE.shift[1]
    else
      @associated_value = nil
    end
    super
  end
  
end
