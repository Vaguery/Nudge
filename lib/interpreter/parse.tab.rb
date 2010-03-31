# encoding: utf-8

require 'racc/parser'
require 'strscan'


class NudgeTree < Racc::Parser

module_eval <<'..end parse.y modeval..ida1760a43d7', 'parse.y', 22
  def self.from(string)
    nt = NudgeTree.new(string)
    result = nt.send(:do_parse)
    {tree:result, unused:nt.footnotes}
  rescue ParseError => exc
    {tree:NilPoint.new, unused:{}}
  end
  
  
  attr_accessor :tree, :footnotes, :unused_footnotes
  
  
  def initialize(string)
    @tokens = []
    @string = string.strip
    @footnotes = Hash.new { |hash, category| hash[category] = [] }
    @unused_footnotes = {}
    self.make_footnotes!
    self.tokenize!
  end
  
  
  def make_footnotes!
    return unless split_point = @string.index(/\n«/um)
    raise ParseError, "No program string" if split_point == 0
    
    ss = StringScanner.new(@string.slice!((split_point)..-1))
    
    fn_head = /\n«([\p{Alpha}][_\p{Alnum}]*)»/u
    
    while ss.exist?(fn_head)
      ss.scan_until(fn_head)
      cat = ss[1]
      if ss.exist?(/\n«/um)
        ss.scan_until(/(.*?)\n«/um)
        fn = ss[1]
      elsif ss.eos?
        fn = ""
      else
        ss.scan_until(/(.*)$/um)
        fn = ss[1]
      end
      ss.pos -= 3
      @footnotes[cat] << fn.strip
    end
  end
  
  
  def pop_footnote(category)
    value = @footnotes[category].shift
    
    if category == "code"
      embedded_footnotes = [""]
      self.collect_embedded_footnotes!(value, embedded_footnotes)
      value += embedded_footnotes.join("\n")
    end
    
    return value
  end
  
  
  def collect_embedded_footnotes!(code_text, embedded_footnotes)
    ss = StringScanner.new(code_text)    
    while ss.skip_until(/«([\p{Alpha}][\p{Alnum}_]*?)»/um)
      category = ss[1]
      footnote = @footnotes[category].shift || ""
      
      embedded_footnotes << "«#{category}» #{footnote}"
      
      if category == "code"
        self.collect_embedded_footnotes!(footnote, embedded_footnotes)
      end
    end
  end
  
  
  def next_token
    return @tokens.shift
  end
  
  
  def tokenize!
    ss = StringScanner.new(@string)
    
    until ss.eos?
      @tokens << case c = ss.getch
        when /\s/
          nil
        when /[{}«»]/
          [c, 0]
        when /[\p{Alpha}]/u
          ss.unscan
          ss.scan(/[\p{Alpha}][_\p{Alnum}]*/u)  # <- \p{Alpha}
          
          case m = ss.matched
            when "block", "ref", "do", "value"
              [m, 0]
            else
              [:ID, m]
          end
        else
          raise ParseError, "Couldn't tokenize program string \"#{@string}\""
      end
    end
    
    @tokens.compact!
    @tokens << [false, false]
  end
  
  
  def on_error(error_token_id, error_value, value_stack)
    raise ParseError, "Couldn't parse program string"
  end

..end parse.y modeval..ida1760a43d7

##### racc 1.4.5 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 4, 12, :_reduce_1,
 2, 12, :_reduce_2,
 2, 12, :_reduce_3,
 4, 12, :_reduce_4,
 1, 13, :_reduce_5,
 2, 13, :_reduce_6,
 0, 13, :_reduce_7 ]

racc_reduce_n = 8

racc_shift_n = 18

racc_action_table = [
     2,    10,     9,     3,     8,     4,     5,     2,    11,    16,
     3,     2,     4,     5,     3,     7,     4,     5,    14,     6,
    17 ]

racc_action_check = [
     0,     5,     4,     0,     3,     0,     0,    13,     6,    13,
    13,     7,    13,    13,     7,     2,     7,     7,    10,     1,
    14 ]

racc_action_pointer = [
    -2,    19,    12,    -2,    -4,    -8,     8,     9,   nil,   nil,
    12,   nil,   nil,     5,    10,   nil,   nil,   nil ]

racc_action_default = [
    -8,    -8,    -8,    -8,    -8,    -8,    -8,    -7,    -2,    -3,
    -8,    18,    -5,    -8,    -8,    -6,    -1,    -4 ]

racc_goto_table = [
     1,    13,   nil,   nil,   nil,   nil,   nil,    12,   nil,   nil,
   nil,   nil,   nil,    15 ]

racc_goto_check = [
     1,     2,   nil,   nil,   nil,   nil,   nil,     1,   nil,   nil,
   nil,   nil,   nil,     1 ]

racc_goto_pointer = [
   nil,     0,    -6 ]

racc_goto_default = [
   nil,   nil,   nil ]

racc_token_table = {
 false => 0,
 Object.new => 1,
 "block" => 2,
 "{" => 3,
 "}" => 4,
 "ref" => 5,
 :ID => 6,
 "do" => 7,
 "value" => 8,
 "«" => 9,
 "»" => 10 }

racc_use_result_var = true

racc_nt_base = 11

Racc_arg = [
 racc_action_table,
 racc_action_check,
 racc_action_default,
 racc_action_pointer,
 racc_goto_table,
 racc_goto_check,
 racc_goto_default,
 racc_goto_pointer,
 racc_nt_base,
 racc_reduce_table,
 racc_token_table,
 racc_shift_n,
 racc_reduce_n,
 racc_use_result_var ]

Racc_token_to_s_table = [
'$end',
'error',
'"block"',
'"{"',
'"}"',
'"ref"',
'ID',
'"do"',
'"value"',
'"«"',
'"»"',
'$start',
'statement',
'statements']

Racc_debug_parser = false

##### racc system variables end #####

 # reduce 0 omitted

module_eval <<'.,.,', 'parse.y', 5
  def _reduce_1( val, _values, result )
 result = CodeblockPoint.new(val[2])
   result
  end
.,.,

module_eval <<'.,.,', 'parse.y', 6
  def _reduce_2( val, _values, result )
 result = ReferencePoint.new(val[1])
   result
  end
.,.,

module_eval <<'.,.,', 'parse.y', 7
  def _reduce_3( val, _values, result )
 result = InstructionPoint.new(val[1])
   result
  end
.,.,

module_eval <<'.,.,', 'parse.y', 8
  def _reduce_4( val, _values, result )
 result = ValuePoint.new(val[2], self.pop_footnote(val[2]))
   result
  end
.,.,

module_eval <<'.,.,', 'parse.y', 11
  def _reduce_5( val, _values, result )
 result = [val[0]]
   result
  end
.,.,

module_eval <<'.,.,', 'parse.y', 12
  def _reduce_6( val, _values, result )
 result = val[0] << val[1]
   result
  end
.,.,

module_eval <<'.,.,', 'parse.y', 13
  def _reduce_7( val, _values, result )
 result = []
   result
  end
.,.,

 def _reduce_none( val, _values, result )
  result
 end

end   # class NudgeTree