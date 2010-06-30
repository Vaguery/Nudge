$: << File.join(File.dirname(__FILE__), "..")
require 'nudge_point'
require 'points/block_point'
require 'points/do_point'
require 'points/ref_point'
require 'points/value_point'
require 'nudge_error'
require 'nudge_instruction'
require 'nudge_parser'
require 'nudge_value'
require 'nudge_writer'
require 'execution/settings'
require 'execution/outcome'
require 'execution/executable'

Dir.glob('instructions/*/*.rb') {|file| require file }
