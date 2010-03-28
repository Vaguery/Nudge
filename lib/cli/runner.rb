#encoding: utf-8

module Nudge
  class CliRunner
    attr_accessor :filename
    attr_accessor :raw_code
    attr_accessor :nudge_program
    attr_accessor :interpreter
    
    def initialize(filename, options={})
      @filename = filename
      @raw_code = IO.open(filename)
      @nudge_program = NudgeProgram.new(@raw_code)
      @interpreter = Interpreter.new
    end
  end
  
  class CliArgParser
  end
  
end