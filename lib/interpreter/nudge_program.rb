#encoding: utf-8
require 'treetop'


module Nudge
  class NudgeProgram
    attr_accessor :code_section, :footnote_section
    attr_accessor :linked_code,:footnotes
    attr_reader :raw_code
    attr_reader :parser
    
    def initialize(sourcecode)
      raise(ArgumentError, "NudgeProgram.new should be passed a string") unless sourcecode.kind_of?(String)
      @raw_code = sourcecode
      program_split!
      @parser = NudgeCodeblockParser.new
      link_code!
    end
    
    
    def program_split!
      split_at_first_guillemet=@raw_code.partition( /^(?=«)/ )
      @code_section = split_at_first_guillemet[0].strip
      @footnote_section = split_at_first_guillemet[2].strip
      @footnotes = parsed_footnotes
    end
    
    
    def parsed_footnotes
      shattered = @footnote_section.split( /^(?=«)/ )
      breaker = /^«([a-zA-Z][a-zA-Z0-9_]*)»\s*(.*)\s*/m
      pairs = shattered.collect {|fn| fn.match(breaker)[1..2]}
      fn = Hash.new {|hash, key| hash[key] = [] }
      pairs.each { |key,value| fn[key.to_sym] << value.chomp}
      return fn
    end
    
    
    def link_code!
      if parses?
        @linked_code = @parser.parse(@code_section).to_point
        depth_first_association!
      else
        @linked_code = nil
      end
    end
    
    
    def depth_first_association!(program_point=@linked_code)
      if program_point.kind_of?(ValuePoint)
        program_point.value = @footnotes[program_point.type].shift
      elsif program_point.kind_of?(CodeblockPoint)
        program_point.contents.each {|branch| depth_first_association!(branch)}
      end
    end
    
    
    def parses?
      (@parser.parse(@code_section) != nil)
    end
    
    
    def tidy
      framework = NudgeCodeblockParser.new.parse(@code_section)
      framework ? framework.tidy : ""
    end
    
    
    def contains_codevalues?
      (@raw_code =~ /value\s*«code»/) != nil
    end
  end
end