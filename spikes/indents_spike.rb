l1 = <<HERE
block 1
  point 2
  point 3
HERE

l2 = <<HERE
point 1
point 2
HERE

l3 = <<HERE
block 1
  block 2
    block 3
    block 4
      block 5
        point 6
    point 7
  point 8
HERE

def lines(string)
  return string.scan(/.+$/)
end

def contents(block)
  indented = block.scan(/^(\s\s(\S.*))/m).flatten
end

p contents(l1)
p contents(l2)
p contents(l3)