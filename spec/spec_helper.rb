$: << File.join(File.dirname(__FILE__), "/../lib") 

require 'spec'
require 'interpreter/treetophelpers'
require 'pp'
require 'nudge'
require 'erb'

include TreetopParserMatchers

def fixture(name, data = binding)
  text = File.read(File.join(File.dirname(__FILE__), "/fixtures/#{name}.example"))
  ERB.new(text).result(data)
end

def load_grammar(name)
  Treetop.load(File.join(File.dirname(__FILE__), '..', 'lib', 'interpreter', 'grammars', "nudge_#{name}.treetop"))
end

module GrammarParsingMatchers
  class ShouldParse
    def initialize(contents, parser)
      @contents = contents
      @parser = parser
    end
    
    def matches?(contents)
      string =
      case @contents
      when String
        @contents
      when File
        raise "shit!"
      end
      
      @parsed_value = @parser.parse(string)
      
      !@parsed_value.nil?
    end
    
    def failure_message
      "expected Parser to #{description} but it did not."
    end
    
    def negative_failure_message
      "expected Parser to not parse #{description} but got syntax tree: #{@parsed_value.inspect}"
    end
    
    def description
      case @contents
      when String
        "parse '#{@contents}'"
      when File
        "parse contents of file #{@contents}"
      end
    end
  end
  class ShouldCapture
    def initialize(name, nodes)
      @name = name
      @nodes = nodes
    end
    
    def matches?(contents)
      captured_name? && captured_with_correct_value?
    end
    
    def failure_message
      "expected parser to capture #{@name.inspect}, but it did not"
    end
    
    def negative_failure_message
      message = "did not expect parser to capture #{@name.inspect}"
      if captured_name?
        message << ", but it captured as #{@nodes.send(@name).inspect}"
      end
      message
    end
    
    def captured_name?
      @nodes.respond_to?(@name)
    end
    
    def captured_with_correct_value?
      return true unless @value
      @nodes.send(@name).text_value == @value
    end
    
    def description
      @description = "capture #{@name}"
      if defined?(@value)
        @description << " as '#{@value}'"
      end
      @description
    end
    
    def as(value)
      @value = value
      self 
    end
  end
  
  def parse(contents)
    ShouldParse.new(contents, @parser)
  end
  def capture(name_as_symbol)
    ShouldCapture.new(name_as_symbol, @parsed)
  end
end
 
Spec::Runner.configure do |config|
  config.include(GrammarParsingMatchers)
end
