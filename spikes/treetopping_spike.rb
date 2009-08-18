require "treetop"
require "polyglot"
require "trees"

parser = NudgelikeParser.new

p parser.parse("block")

p parser.parse("block\n  block")