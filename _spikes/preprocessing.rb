#encoding: utf-8
program = <<-ENDME

block {
  value «string»
  value «int»
  value «image»
}

«string» hi there \n we have some lines 
       with extra space
\t here!
«int» 88
«image» http://mypath.com/somefile.jpg
«string» some extra one with a «blob» in it (and some ' and "' " quotes)
«blob» also works with ǝpoɔıun

ENDME

blueprint, spacer, fn = program.partition( /^(?=«)/ )

eachfn = fn.split( /^(?=«)/ )

breaker = /^«([a-zA-Z][a-zA-Z0-9_]*)»(.*)/m

pieces = eachfn.collect {|fn| fn.match(breaker)[1..2]}

puts  blueprint 
puts "\nchunks:\n" + eachfn.inspect
puts "\nsliced chunks:\n"
pieces.each do |fn|
  puts " type: #{fn[0]}\n"
  puts " value:#{fn[1].inspect}\n\n"
end