#coding: utf-8
require 'strscan'
# require '../lib/nudge'



class NudgeScanner
  attr_reader :block_regex, :ref_regex, :do_regex, :value_regex
  attr_reader :point_regex
  
  def initialize
    @block_regex = /block {(.*)}/m
    @ref_regex = /ref (\p{Alnum}[_\p{Alnum}]*)/m
    @do_regex = /do (\p{Alnum}[_\p{Alnum}]*)/m
    @value_regex = /value «(\p{Alnum}[_\p{Alnum}]*)»/m
    
    @point_regex = Regexp.union(@block_regex, @ref_regex, @do_regex, @value_regex)
  end
  
  def scannit(string, depth = 1)
    ss = StringScanner.new(string)
    ss.scan_until(@point_regex)
    if ss.matched?
      puts "•#{depth}• #{ss.matched.inspect}"
      scannit(ss[1].strip, depth+1) unless (ss[1] == nil)
      scannit(ss.rest, depth+1) unless ss.rest == ""
    end
  end
end


ns = NudgeScanner.new
ns.scannit("block { ref a_1\ndo int_thing\n  ref b value «int» block {ref a_1} block {ref c}}")

ns.scannit("ref a_1")

ns.scannit("some random crap")
