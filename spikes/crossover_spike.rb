# exploring the operator prospects of pure-text point-per-line Nudge representation


l1 = <<HERE
erc :int, -133
opc :int_add
block
  erc :bool, false
  opc :int_sub
  opc :bool_and
  opc :code_quote
  channel 'x1'
  erc :int, 800
  opc :code_quote
  block
    opc :int_neg
    opc :int_dup
    block
    block
      opc :bool_xor
erc :bool, true
opc :code_if
HERE
listing1 = Code.new(l1)


l2 = <<HERE
opc :exec_dup
erc :int, 4
opc :int_rand
opc :int_dup
opc :int_shove
HERE
listing2 = Code.new(l2)


puts listing1.anypoint # produces one of 19 different subexpressions (including listing1)

puts listing1.points # returns 19

puts listing1.all_points # returns array of all 19 points, some multiline

listing1.point(16) # NOTE that this is 1-based
result = <<HERE
block
  opc :bool_xor
HERE

listing1.delete_point(12) # returns
result = <<HERE
erc :int, -133
opc :int_add
block
  erc :bool, false
  opc :int_sub
  opc :bool_and
  opc :code_quote
  channel 'x1'
  erc :int, 800
  opc :code_quote
erc :bool, true
opc :code_if
HERE

listing1.blocks # returns 5
listing1.all_blocks # returns array of all 5 subexpressions starting with 'block'

listing1.instructions # returns 9
listing1.all_instructions # returns array of 9 individual lines

listing1.ERCs # returns 4
listing1.all_ERCs # returns array of 4 individual lines

listing1.channels # returns 1
listing1.all_channels # returns array of 1 individual line

listing1.flatten # returns
result = <<HERE
erc :int, -133
opc :int_add
erc :bool, false
opc :int_sub
opc :bool_and
opc :code_quote
channel 'x1'
erc :int, 800
opc :code_quote
opc :int_neg
opc :int_dup
opc :bool_xor
erc :bool, true
opc :code_if
HERE

listing1.flatten_to(2) # returns
result = <<HERE
erc :int, -133
opc :int_add
block
  erc :bool, false
  opc :int_sub
  opc :bool_and
  opc :code_quote
  channel 'x1'
  erc :int, 800
  opc :code_quote
  block
    opc :int_neg
    opc :int_dup
    opc :bool_xor
erc :bool, true
opc :code_if
HERE

listing1.promote_range(2,7) # [and also .promote_range(7,2)]
listing1 = <<HERE
erc :int, -133
block
  opc :int_add
  block
    erc :bool, false
    opc :int_sub
    opc :bool_and
    opc :code_quote
  channel 'x1'
  erc :int, 800
  opc :code_quote
  block
    opc :int_neg
    opc :int_dup
    block
    block
      opc :bool_xor
erc :bool, true
opc :code_if
HERE

simple1 = <<HERE
erc :int, 1
erc :int, 2
erc :int, 3
erc :int, 4
erc :int, 5
erc :int, 6
erc :int, 7
erc :int, 8
erc :int, 9
erc :int, 10
HERE

not_simple = simple1.promote_range(2,8).promote_range(3,5).promote_range(1,4)
not_simple = <<HERE
block
  erc :int, 1
  block
    block
      erc :int, 2
    erc :int, 3
    erc :int, 4
  erc :int, 5
  erc :int, 6
  erc :int, 7
  erc :int, 8
erc :int, 9
erc :int, 10
HERE
# [ 1,2,3,4,5,6,7,8,9,10 ] ->
# [ 1,[ 2,3,4,5,6,7,8 ],9,10 ] -> 
# [ 1,[ [ 2,3,4 ],5,6,7,8 ],9,10 ] ->
# [ [1,[ [ 2 ],3,4 ],5,6,7,8 ],9,10 ]


listing1.resample # resamples values of all ERCs, within current context

# crossover
# mutation