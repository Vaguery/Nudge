#!/usr/bin/env ruby -E utf-8 
require '../lib/nudge'
require 'optparse'
include Nudge

@filename = ARGV[0]

ii = Interpreter.new
prog = NudgeProgram.new(IO.read(@filename))

ii.reset(prog.blueprint)
ii.register_sensor("y1") {|me| me.pop_value(:int) }
ii.register_sensor("y2") {|me| me.pop_value(:bool) }

puts prog.blueprint.inspect
puts ii.run
