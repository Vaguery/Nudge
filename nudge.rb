require 'nudge_point'
require 'points/block_point'
require 'points/do_point'
require 'points/ref_point'
require 'points/value_point'
require 'nudge_parser'
require 'nudge_type'
require 'execution/settings'
require 'execution/outcome'
require 'execution/executable'
require 'instructions/instruction'

Dir.glob('instructions/*/*.rb') {|file| require file }
