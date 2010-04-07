$: << File.join(File.dirname(__FILE__), "/../lib") 

require 'rubygems'
require 'active_support'

require 'interpreter/parse.tab'

require 'interpreter/nudge_program'

require 'cli/runner'

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

Dir.glob(File.dirname(__FILE__) + '/instructions/conversion/*') {|file| require file}

include NudgeType