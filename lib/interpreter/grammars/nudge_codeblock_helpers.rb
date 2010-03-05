# coding: utf-8
module CodeblockParseNode
  def contents
    block_contents.elements.collect {|e| e.elements[0]}
  end
  
  def tidy(level=1)
    tt = "block {"
    indent = level*2
    contents.each {|item| tt += ("\n" + (" "*indent) + item.tidy(level+1))}
    tt += "}"
    return tt
  end
  
  def to_point
    c = CodeblockPoint.new(contents.collect {|e| e.to_point})
  end
end

