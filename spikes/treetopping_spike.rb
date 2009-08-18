require "treetop"
require "polyglot"
require "trees"

parser = NudgelikeParser.new

p parser.parse("")

p parser.parse("123")

p parser.parse("123\n456")