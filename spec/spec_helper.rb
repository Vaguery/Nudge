$: << File.join(File.dirname(__FILE__), "/../lib") 

require 'rubygems' 
require 'spec'

require 'interpreter/stack'
require 'interpreter/leaves'
require 'interpreter/code'
require 'interpreter/channel'
require 'interpreter/interpreter'

require 'instructions/infrastructure.rb'
require 'instructions/int_arithmetic.rb'