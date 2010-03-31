#coding: utf-8
require 'strscan'
require 'pp'
require 'nudge'
include Nudge



class NudgeScanner
  attr_reader :block_regex, :ref_regex, :do_regex, :value_regex
  attr_reader :point_regex
  
  def initialize
    @block_start = /block[\t\s]*{/
    @ref_regex = /ref (\p{Alnum}[_\p{Alnum}]*)/m
    @do_regex = /do (\p{Alnum}[_\p{Alnum}]*)/m
    @value_regex = /value «(\p{Alnum}[_\p{Alnum}]*)»/m
    
    @point_regex = Regexp.union(@block_start, @ref_regex, @do_regex, @value_regex)
  end
  
  def scannit(string, result = [])
    ss = StringScanner.new(string)
    ss.scan_until(@point_regex)
    if ss.matched?
      if ss.matched.include? "block"
        contents = ""
        nesting = 1
        while nesting > 0
          ss.getch
          ch = ss.matched
          nesting += 1 if ch == '{'
          nesting -= 1 if ch == '}'
          contents << ch
        end
        contents.chop!
        result << scannit(contents)# unless (contents == "")
      else
        result << ss.matched
        scannit(ss[1].strip,result) unless (ss[1] == nil)
      end
      scannit(ss.rest, result) unless ss.rest == ""
    end
    return result
  end
  
end

collection = []
cases = 500
pts = 100

cases.times do
  collection << CodeType.any_value(target_size_in_points:pts, reference_names:["x1","x2"],
    type_names:["int", "bool", "code"])
end

t1 = Time.now
collection.each do |g|
  NudgeCodeblockParser.new.parse(g)
end

t2 = Time.now
collection.each do |g|
  NudgeScanner.new.scannit(g)
end
t3 = Time.now
collection.each do |g|
  NudgeTree.from(g)[:tree]
end
t4 = Time.now

puts "(sec/tree) for #{pts} points\nparser:  #{(t2-t1)/cases.to_f} \nstrscan: #{(t3-t2)/cases.to_f}\njesse_parser: #{(t4-t3)/cases.to_f}"