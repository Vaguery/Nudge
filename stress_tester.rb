# encoding: UTF-8
require File.expand_path("nudge", File.dirname(__FILE__))

puts "points, steps, time, :bool, :code, :error, :exec, :float, :int, :proportion"

100000.times do
  begin

    script = NudgeWriter.new.random
    exe = NudgeExecutable.new(script)
    exe.set_options(point_limit:20000, time_limit:20)

    exe.bind(:x1 => Value.new(:int, 100), :x2 => Value.new(:bool, false))
  
    o = exe.run
    
    raise "INFINITY in :int" if o.stacks[:int].any? {|i| i =~ /Infi/}
    raise "INFINITY in :float" if o.stacks[:float].any? {|i| i =~ /Infi/}
    
    puts "#{NudgePoint.from(script).points}, #{o.points_evaluated}, #{o.time_elapsed}, #{o.stacks[:bool].length}, #{o.stacks[:code].length}, #{o.stacks[:error].length}, #{o.stacks[:exec].length}, #{o.stacks[:float].length}, #{o.stacks[:int].length}, #{o.stacks[:proportion].length}"
  
  rescue => err
    puts "----------"
    puts "FAILED after #{exe.points_evaluated} steps with err \"#{err}\""
    puts "----------"
    puts script
    puts "----------"
  end
end
