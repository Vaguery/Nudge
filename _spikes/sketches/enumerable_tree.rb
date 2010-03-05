class Tree
  include Enumerable
  
  attr_accessor :nodes
  
  def init(array)
    @nodes  = array
  end
  
  def each
    @nodes.contents do |node|
      yield node
    end
  end
end


class BlockNode
  attr_accessor :contents
  
  def init(array)
    @contents = array
  end
end


class LeafNode
  attr_accessor :name, :contents
  
  def init(name="a")
    @name = name
    @contents = []
  end
end