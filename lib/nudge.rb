$: << File.join(File.dirname(__FILE__), "/../lib") 

require 'rubygems'
require 'treetop'
require 'polyglot'
require 'activesupport'


require 'interpreter/grammars/nudge_language_helpers'
require 'interpreter/grammars/nudge_language'
require 'interpreter/interpreter'

require 'interpreter/types/pushTypes'
require 'interpreter/stack'
require 'interpreter/programPoints'

require 'search/helpers'
require 'instructions/infrastructure'
require 'instructions/int_stack'
require 'instructions/int_arithmetic'
require 'instructions/float_arithmetic'
require 'instructions/bool_basics'
require 'instructions/comparisons'


require 'search/individual/individual'
require 'search/operators/basic_operators'
require 'search/evaluators/structural_complexity'
