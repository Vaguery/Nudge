# encoding: UTF-8
require 'racc/parser'
require 'strscan'

class NudgeParser < Racc::Parser
  def initialize (script)
    @tokens = []
    @footnotes = Hash.new {|hash, value_type| hash[value_type] = [] }
    
    script = script.rstrip
    
    if split_point = script.index(/\n«/u)
      raise NudgeError::InvalidScript, "script contains only footnotes" if split_point == 0
      
      ss = StringScanner.new(script.slice!(split_point..-1))
      
      while ss.scan_until(/\n«([a-zA-Z][_a-zA-Z0-9]*)»/u)
        value_type = ss[1].intern
        value_string = ss.scan_until(/.*?(?=\n«|$)/um).strip
        
        @footnotes[value_type] << value_string
      end
    end
    
    ss = StringScanner.new(script)
    
    until ss.eos?
      @tokens << case c = ss.getch
        when /\s/
          nil
        
        when /[{}«»]/u
          [c, 0]
        
        when /[a-zA-Z]/
          ss.unscan
          ss.scan(/[a-zA-Z][_a-zA-Z0-9]*[?]?/)
          
          case m = ss.matched.intern
            when :block, :ref, :do, :value
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
  
  private
  
  def next_token
    @tokens.shift
  end
  
  def new_block_point (v, *)
    BlockPoint.new(*v[2])
  end
  
  def new_ref_point (v, *)
    RefPoint.new(v[1])
  end
  
  def new_do_point (v, *)
    DoPoint.new(v[1])
  end
  
  def new_value_point (v, *)
    value_type = v[2]
    
    raise NudgeError::InvalidScript, "script contains «exec» literals" if value_type == :exec
    
    if value_string = @footnotes[value_type].shift
      if value_type == :code
        embedded_footnotes = [""]
        collect_embedded_footnotes!(value_string, embedded_footnotes)
        value_string += embedded_footnotes.join("\n")
      end
    else
      value_string = ""
    end
    
    ValuePoint.new(value_type, value_string)
  end
  
  def collect_embedded_footnotes! (code_text, embedded_footnotes)
    ss = StringScanner.new(code_text)
    
    while ss.skip_until(/«([a-zA-Z][_a-zA-Z0-9]*?)»/um)
      value_type = ss[1].intern
      value_string = @footnotes[value_type].shift
      
      raise NudgeError::InvalidScript, "script contains «exec» literals" if value_type == :exec
      
      embedded_footnotes << "«#{value_type}»#{value_string}"
      
      if value_type == :code && value_string
        collect_embedded_footnotes!(value_string, embedded_footnotes)
      end
    end
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
  
  def on_error (*)
    raise NudgeError::InvalidScript, "script tokens do not form valid Nudge program"
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
    { false => 0, Object.new => 1, :block => 2, "{" => 3, "}" => 4, :ref => 5, :ID => 6, :do => 7, :value => 8, "«" => 9, "»" => 10 },
    18,
    8,
    true
  ]
end
