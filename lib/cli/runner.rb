#encoding: utf-8

module Nudge
  class CliRunner
    attr_accessor :filename
    attr_accessor :raw_code
    attr_accessor :nudge_program
    attr_accessor :interpreter
    attr_accessor :options
    attr_accessor :result
    
    
    def initialize(filename, options={})
      @filename = filename
      @nudge_program = NudgeProgram.new("")
      @options = options
      @interpreter = Interpreter.new(@options)
    end
    
    
    def setup
      @raw_code = IO.open(@filename)
      @interpreter.reset(@raw_code)
    end
    
    
    def run
      return @interpreter.run
    end
  end
  
end