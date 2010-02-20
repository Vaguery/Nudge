# coding: utf-8
module CodeblockProgramPoint
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
  
end

