require '../lib/nudge'
include Nudge

params = {:blocks => 7,:types => [IntType], :references => ["x","y"],
  :instructions => [IntAddInstruction, IntSubtractInstruction]}
  
guesser = RandomGuess.new(params)

myGuy = guesser.generate[0]
myCode = myGuy.program.tidy
puts myCode

lines = myCode.split(/\n/)

lines.each do |line|
  line =~ /^([\s]*)/
  indent = $1
  p indent
  # p line.index(indent)
end