NUDGE_ROOT = '.' unless defined? NUDGE_ROOT

require "#{NUDGE_ROOT}/nudge_point"
require "#{NUDGE_ROOT}/points/block_point"
require "#{NUDGE_ROOT}/points/do_point"
require "#{NUDGE_ROOT}/points/ref_point"
require "#{NUDGE_ROOT}/points/value_point"
require "#{NUDGE_ROOT}/nudge_error"
require "#{NUDGE_ROOT}/nudge_instruction"
require "#{NUDGE_ROOT}/nudge_parser"
require "#{NUDGE_ROOT}/nudge_value"
require "#{NUDGE_ROOT}/nudge_writer"
require "#{NUDGE_ROOT}/execution/settings"
require "#{NUDGE_ROOT}/execution/outcome"
require "#{NUDGE_ROOT}/execution/executable"

Dir.glob("#{NUDGE_ROOT}/instructions/*/*.rb") {|file| require file }
