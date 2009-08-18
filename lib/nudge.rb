$: << File.join(File.dirname(__FILE__), "/../lib") 

require "treetop"
require "polyglot"


require 'interpreter/stack'
require 'interpreter/grammars/nudge_language'

require 'instructions/int_arithmetic.rb'
