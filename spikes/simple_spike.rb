$: << File.join(File.dirname(__FILE__), "../lib") 

require 'nudge'
require 'pp'
require 'yaml'

include Interpreter


stacks = {}
stacks[:exec] = Stack.new(:exec)
stacks[:int] = Stack.new(:int)
stacks[:bool] = Stack.new(:bool)

pp stacks
puts "\n"

i3 = Literal.new(3,:int)
in22 = Literal.new(-22,:int)
bf = Literal.new(false,:bool)
bf2 = Literal.new(false,:bool)
bt = Literal.new(true,:bool)

ei = Erc.new(3, :int)

nested = Code.new([i3,in22])

test_code = Code.new([nested, bf, bf2, bt, ei])
pp test_code
puts "\n"

stacks[:exec].push test_code

y = YAML.dump stacks[:exec]
puts y