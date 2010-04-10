#encoding: utf-8
require 'nudge'
include Nudge

@wt = NudgeProgram.random(target_size_in_points:40)

def scanning_mutagenesis
  (0..@wt.tidy.length).each do |char|
    zapped = @wt.blueprint.clone
    zapped[char] = 'X'
    mutant = NudgeProgram.new(zapped)
    puts "#{zapped.inspect},#{mutant.parses?}"
  end
end

def scanning_deletion
  (1..20).each do |pt|
    zapped = @wt.delete_point(pt)
    puts "#{zapped.blueprint.inspect},#{zapped.parses?}"
  end
end

scanning_mutagenesis
puts "\n\n"
scanning_deletion