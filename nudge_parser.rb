# encoding: UTF-8
require 'racc/parser'
require 'strscan'

class NudgeParser < Racc::Parser
  def initialize (script)
    @tokens = []
    @string = script.strip
    @footnotes = Hash.new {|hash, type_name| hash[type_name] = [] }
    
    parse_footnotes!
    tokenize!
  end
  
  def parse_footnotes!
    return unless split_point = @string.index(/\n«/u)
    
    raise NudgeError::InvalidScript, "script contains only footnotes" if split_point == 0
    
    ss = StringScanner.new(@string.slice!(split_point..-1))
    
    while ss.scan_until(/\n«([a-zA-Z][_a-zA-Z0-9]*)»/u)
      type_name = ss[1]
      string_value = ss.scan_until(/.*?(?=\n«|$)/um)
      
      @footnotes[type_name] << string_value.strip
    end
  end
  
  def tokenize!
    ss = StringScanner.new(@string)
    
    until ss.eos?
      @tokens << case c = ss.getch
        when /\s/
          nil
        
        when /[{}«»]/u
          [c, 0]
        
        when /[a-zA-Z]/
          ss.unscan
          ss.scan(/[a-zA-Z][_a-zA-Z0-9]*[?]?/)
          
          case m = ss.matched
            when "block", "ref", "do", "value"
              [m, 0]
            else
              [:ID, m]
          end
        
        else
          raise NudgeError::InvalidScript, "script contains invalid tokens"
      end
    end
    
    @tokens.compact!
    @tokens << [false, false]
  end
  
  def use_footnote (type_name)
    return "" unless string_value = @footnotes[type_name].shift
    
    raise NudgeError::InvalidScript "script contains «exec» literals" if type_name === "exec"
    
    if type_name === "code"
      embedded_footnotes = [""]
      collect_embedded_footnotes!(string_value, embedded_footnotes)
      string_value += embedded_footnotes.join("\n")
    end
    
    string_value
  end
  
  def collect_embedded_footnotes! (code_text, embedded_footnotes)
    ss = StringScanner.new(code_text)
    
    while ss.skip_until(/«([a-zA-Z][_a-zA-Z0-9]*?)»/um)
      type_name = ss[1]
      string_value = @footnotes[type_name].shift
      
      raise NudgeError::InvalidScript "script contains «exec» literals" if type_name === "exec"
      
      embedded_footnotes << "«#{type_name}»#{string_value}"
      
      if type_name == "code" && string_value
        collect_embedded_footnotes!(string_value, embedded_footnotes)
      end
    end
  end
  
  def on_error (*)
    raise NudgeError::InvalidScript, "script tokens do not form valid Nudge program"
  end
  
  def next_token
    @tokens.shift
  end
  
  def new_block_point (v, *)
    BlockPoint.new(*v[2])
  end
  
  def new_ref_point (v, *)
    RefPoint.new(v[1].intern)
  end
  
  def new_do_point (v, *)
    DoPoint.new(v[1].intern)
  end
  
  def new_value_point (v, *)
    ValuePoint.new(v[2].intern, use_footnote(v[2]))
  end
  
  def new_point_array (v, *)
    [v[0]]
  end
  
  def new_empty_array (*)
    []
  end
  
  def append_point (v, *)
    v[0] << v[1]
  end
  
  Racc_debug_parser = false
  Racc_arg = [
    [2,10,9,3,8,4,5,2,11,16,3,2,4,5,3,7,4,5,14,6,17],
    [0,5,4,0,3,0,0,13,6,13,13,7,13,13,7,2,7,7,10,1,14],
    [-8,-8,-8,-8,-8,-8,-8,-7,-2,-3,-8,18,-5,-8,-8,-6,-1,-4],
    [-2,19,12,-2,-4,-8,8,9,nil,nil,12,nil,nil,5,10,nil,nil,nil],
    [1,13,nil,nil,nil,nil,nil,12,nil,nil,nil,nil,nil,15],
    [1,2,nil,nil,nil,nil,nil,1,nil,nil,nil,nil,nil,1],
    [nil,nil,nil],
    [nil,0,-6],
    11,
    [0, 0, :racc_error, 4, 12, :new_block_point, 2, 12, :new_ref_point, 2, 12, :new_do_point, 4, 12, :new_value_point, 1, 13, :new_point_array, 2, 13, :append_point, 0, 13, :new_empty_array],
    { false => 0, Object.new => 1, "block" => 2, "{" => 3, "}" => 4, "ref" => 5, :ID => 6, "do" => 7, "value" => 8, "«" => 9, "»" => 10 },
    18,
    8,
    true
  ]
end
