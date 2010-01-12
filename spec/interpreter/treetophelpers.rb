module TreetopParserMatchers 
  class ParserMatcher 
    def initialize(input_string) 
      @input_string = input_string 
    end 
    def matches?(parser) 
      @parser = parser 
      !@parser.parse(@input_string).nil? 
    end 
    def failure_message_for_should 
      "expected #{@parser} to parse '#{@input_string}'\n" + 
      "failure column: #{@parser.failure_column}\n" + 
      "failure index: #{@parser.failure_index}\n" + 
      "failure line: #{@parser.failure_line}\n" + 
      "failure reason: #{@parser.failure_reason}\n" 
    end 
    def failure_message_for_should_not 
      "expected #{@parser} not to parse '#{@input_string}'" 
    end 
    def description 
      "parse `#{@input_string}'" 
    end 
  end 
  def treetop_parse(input_string) 
    ParserMatcher.new(input_string) 
  end 
end 
