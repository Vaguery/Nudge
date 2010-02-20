#encoding: utf-8
require 'treetop'


module Nudge

  class NudgeProgram
    attr_accessor :code_section, :footnote_section
    attr_accessor :footnotes
    attr_accessor :program_points
    attr_reader :raw_code
    
    def initialize(sourcecode)
      raise(ArgumentError, "NudgeProgram.new should be passed a string") unless sourcecode.kind_of?(String)
      @raw_code = sourcecode
      program_split!
    end
    
    
    def program_split!
      split_at_first_guillemet=@raw_code.partition( /^(?=«)/ )
      @code_section = split_at_first_guillemet[0].strip
      @footnote_section = split_at_first_guillemet[2].strip
      
      shattered = @footnote_section.split( /^(?=«)/ )
      breaker = /^«([a-zA-Z][a-zA-Z0-9_]*)»\s*(.*)\s*/m
      @footnotes = shattered.collect {|fn| fn.match(breaker)[1..2]}
    end
    
    
    def parses?
      (NudgeCodeblockParser.new.parse(@code_section) != nil)
    end
    
    
    def tidy
      frame = NudgeCodeblockParser.new.parse(@code_section)
      frame ? frame.tidy : ""
    end
  end
  
  
end