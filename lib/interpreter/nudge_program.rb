#encoding: utf-8
module Nudge
  class NudgeProgram
    attr_accessor :code_section, :footnote_section
    attr_accessor :footnotes
    attr_reader :raw_code
    
    def initialize(program)
      raise(ArgumentError, "NudgeProgram.new should be passed a string") unless program.kind_of?(String)
      @raw_code = program
      program_split(program)
    end
    
    def program_split(program)
      split_at_first_guillemet=program.partition( /^(?=«)/ )
      @code_section = split_at_first_guillemet[0].strip
      @footnote_section = split_at_first_guillemet[2].strip
      
      shattered = @footnote_section.split( /^(?=«)/ )
      breaker = /^«([a-zA-Z][a-zA-Z0-9_]*)»(.*)/m
      @footnotes = shattered.collect {|fn| fn.match(breaker)[1..2]}
    end
    
  end
end