require 'pp'

class Tree
  attr_reader :name
  
  def initialize(name)
    @name = name
    @contents = []
  end
  
  def <<(name)
    subtree = Tree.new(name)
    @contents << subtree
    return subtree
  end
  
  def traverse(cc=0)
    cc += 1
    # p @name, cc
    @contents.each do |child|
      cc = child.traverse(cc)
    end
    return cc
  end
  
  def all_points(counter=0, collected=[])
    counter += 1
    collected << self
    # p collected
    @contents.each do |child|
      counter, collected = child.all_points(counter, collected)
    end
    return counter, collected
  end 

  
end

t = Tree.new("root")
c1 = t << "child 1"
c1 << "grandchild 1"
c2 = t << "child 2"
c3 = t << "child 3"
g2 = c3 << "grandchild 2"
g2 << "gg 1"

puts t.traverse.to_s + " points"

puts "\n\n"
pp t.all_points[1]
pp t.all_points[1]