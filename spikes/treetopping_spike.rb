require "treetop"
require "polyglot"
require "trees"

parser = NudgelikeParser.new

p parser.parse("block and more junk")

p parser.parse("instr 'int_add'")