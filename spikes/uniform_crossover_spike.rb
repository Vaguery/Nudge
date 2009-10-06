require '../lib/nudge'
require 'pp'
include Nudge


setup = {:points => 20,:blocks => 3,:types =>[IntType], :references => ["x","y","z"], :instructions => [IntAddInstruction, IntSubtractInstruction, IntMultiplyInstruction, IntNegativeInstruction]}


g1 = CodeType.random_value(setup)
g2 = CodeType.random_value(setup)
mom = Individual.new(g1)
dad = Individual.new(g2)

puts "\n== MOM =========="
puts "\n" + mom.program.tidy + "\n\n"
puts mom.program.points.to_s + " points"
puts mom.program.contents.length.to_s + " base points"

puts "\n== DAD =========="
puts "\n" + dad.program.tidy + "\n\n"
puts dad.program.points.to_s + " points"
puts dad.program.contents.length.to_s + " base points"

baby = "block {\n"
(0..mom.program.contents.length-1).each do |point|
  if rand() < 0.5
    baby << mom.program.contents[point].tidy + "\n"
  else
    begin
      baby << dad.program.contents[point].tidy + "\n"
    rescue
      baby << mom.program.contents[point].tidy + "\n"
    end
  end
end
baby << "}"

xover = Individual.new(baby)
puts "\n== KID ========="
puts "\n" + xover.program.tidy + "\n\n"
puts xover.program.points.to_s + " points"
puts xover.program.contents.length.to_s + " base points"

