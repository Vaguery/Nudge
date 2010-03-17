#coding: utf-8
require 'strscan'
# require '../lib/nudge'



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
  
  def scannit(string, point = 1)
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
        puts "•#{point}• block {#{contents}}"
        scannit(contents, point+1) unless (contents == "")
      else
        puts "•#{point}• #{ss.matched}"
        scannit(ss[1].strip, point+1) unless (ss[1] == nil)
      end
      scannit(ss.rest, point+1) unless ss.rest == ""
    end
  end
end


ns = NudgeScanner.new
ns.scannit("block {block {ref aaa001 do bool_xor block {} block {block {block {}}  } ref aaa002 } block {block {value «float» block {value «int» value «bool» } } value «bool» do bool_flush } do float_shove block {value «float» ref aaa003 block {value «bool» ref aaa004 block {value «float» } ref aaa005 } } block {value «int» do exec_y do name_rotate } ref aaa006 block {value «bool» block {} ref aaa007 value «bool» } value «int» do name_pop do int_shove block {do float_if do float_cosine } value «bool» value «float» do bool_define do int_flush block {} block {block {ref aaa008 value «float» value «bool» ref aaa009 value «bool» do exec_define } } do name_swap do code_name_lookup value «bool» ref aaa010 block {value «float» do float_yank } value «float» value «code» block {ref aaa011 value «int» value «int» block {} block {} do bool_xor block {do bool_yankdup ref aaa012 ref aaa013 } ref aaa014 do exec_k } value «int» block {ref aaa015 value «code» value «float» } ref aaa016 ref aaa017 ref aaa018 value «int» ref aaa019 block {ref aaa020 value «float» do name_pop block {block {block {} } } value «code» } block {ref aaa021 ref aaa022 } block {}}")

# ns.scannit("ref a_1")
# 
# ns.scannit("some random crap")
