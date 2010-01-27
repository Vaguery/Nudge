program = <<-ENDME
block {
  literal int(4)
  literal string(2)
  literal image (11)
}

«2» hi there \n we have some lines \t here!
«4» 88
«11» http://mypath.com/somefile.jpg
«88» some extra one with a «3» in it (and some ' and "' " quotes)
«99» also works with ǝpoɔıun

ENDME

listing, spacer, fn = program.partition( /^(?=«[\d]+»)/ )

eachfn = fn.split ( /^(?=«[\d]+»)/ )

breaker = /^«([\d]+)»\s*(.*)/

footnotes = Hash[ eachfn.collect {|fn| breaker.match(fn)[1..2]}]

puts footnotes.inspect