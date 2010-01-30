# coding: utf-8
module CodeblockProgramPoint
  def contents
    @contents = block_contents.elements.collect {|e| e.elements[0]}
  end
end
