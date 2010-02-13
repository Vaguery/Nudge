# this will be the "native" code for the Nudge2.1 language interpreter:

# here's a program, with the four point types shown (block, value, ref, do):

block {
  value «int»
  do int_add
  block {
    value «bool»
    do int_subtract
    do bool_and
    do code_quote
    ref x1
    value «int» 
    do code_quote
    block {
      do int_negate
      do int_duplicate
      block {}
      block {
        do bool_xor}}}
  value «bool»
  do code_if}
  
«int» -133
«bool» false
«int» 800
«bool» true


# here's a "flat" multiline program in Nudge2.1

block {
  do exec_duplicate
  value «int»
  do int_random
  do int_duplicate
  do int_shove
  value «int»}
  
«int» 4
«int» -99

# and here's a "one-line" program (without an initial block):

value «int»

«int» 66




# This suggests representations for other interpreters, too
# here's one for Koza-style S-expressions:

arity2 :add
  arity2 :subtract
    arity1 :negative
      binding 'x'
    arity2 :add
      erc :int, 12
      arity2 :multiply
        erc :float, 9.12
        binding 'y'
  erc :float, -18.91
# (-x - ( 12 + 9.12 * y ) ) + -18.91
# the syntax check is: every arityX line must have X lines at the next-higher indent


#here's a more complex example, just to explore more:

arity2 :multiply
  arity2 :multiply
    arity2 :multiply
      binding 'profit'
      arity2 :add
        erc :int, 12
        binding 'drawdown'
    binding 'profit'
  arity4 :if_LTE
    binding 'volatility'
    erc :int, 8100
    arity2 :add
      binding 'profit'
      binding 'drawdown'
    arity2 :multiply
      erc :proportion, 0.71
      erc :int, 100
#  (profit * (12 + drawdown)) * profit * \
#  (IF volatility ≤ 8100 THEN (profit + drawdown) ELSE (0.71 * 100))


# how far can this go? How about a linear GP interpreter?
# based on Langdon & Banzhaf, GECCO 2004 "Repeated Sequences in Liner GP Genomes"
# there are 8 registers r0-r7, initialized to input values
# each instruction has
#  a register to write the result,
#  a register as 1st operand,
#  an opcode, and
#  a register or integer in [0,127]
# result is found in r0 at the end of serial execution


into r0
  arity2 :add
    register r0
    register r1
into r3
  arity2 :multiply
    register r0
    literal 3
into r2
  arity2 :subtract
    register r1
    erc :int, 71
into r1
  arity2 :subtract
    register r0
    register r3
into r0
  arity2 :add
    register r3
    register r2


# And how about a DataPageant interpreter version?
# each node has
#  an opcode
#  a set of input ports for arguments,
#    referenced by absolute or relative order in program [modulo length]


[1]
  arity1 :read
    channel 'price'
[2]
  arity1 :read
    channel 'volatility'
[3]
  arity1 :read
    channel 'mass'
[4]
  arity1 :read
    relative +2
[5]
  arity2 :add
    relative -2
    relative -5
[6]
  arity3 :min
    relative +3
    absolute -2 # second value from the end of program
    relative +121
[7]
  arity1 :neg
    relative -2    
  