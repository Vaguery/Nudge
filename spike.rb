require 'nudge'

oc = Outcome.new({})
oc.stacks[:int] = ["8","91"]
IntSubtract.new(oc).execute
puts oc.inspect


oc = Outcome.new({})
oc.stacks[:int] = ["8","91"]
IntSubtract.new(oc).execute(wtf=true)
puts oc.inspect