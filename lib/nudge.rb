$: << File.join(File.dirname(__FILE__), "/../lib") 

require 'rubygems'
require 'treetop'
require 'active_support'

require 'interpreter/parse.tab'


require 'interpreter/grammars/nudge_common'

require 'interpreter/grammars/nudge_value_helpers'
require 'interpreter/grammars/nudge_reference_helpers'
require 'interpreter/grammars/nudge_instruction_helpers'
require 'interpreter/grammars/nudge_codeblock_helpers'
require 'interpreter/grammars/nudge_reference'
require 'interpreter/grammars/nudge_instruction'
require 'interpreter/grammars/nudge_value'
require 'interpreter/grammars/nudge_codeblock'

require 'interpreter/nudge_program'

require 'interpreter/interpreter'
require 'interpreter/types/pushTypes'
require 'interpreter/types/codeType'
require 'interpreter/stack'
require 'interpreter/programPoints'

require 'instructions/infrastructure'

Dir.glob(File.dirname(__FILE__) + '/instructions/bool/*') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/instructions/code/*') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/instructions/exec/*') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/instructions/int/*') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/instructions/float/*') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/instructions/name/*') {|file| require file}

require 'instructions/int_arithmetic'
require 'instructions/float_arithmetic'
require 'instructions/float_transcendental'
require 'instructions/conversions'
require 'instructions/random_value'
require 'instructions/exec'
require 'instructions/name_bindings'
require 'instructions/name_basics'





include NudgeType