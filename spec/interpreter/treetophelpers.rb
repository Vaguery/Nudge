# module TreetopParserMatchers 
#   class ParserMatcher 
#     def initialize(input_string) 
#       @input_string = input_string 
#     end 
#     def matches?(parser) 
#       @parser = parser 
#       !@parser.parse(@input_string).nil? 
#     end 
#     def failure_message_for_should 
#       "expected #{@parser} to parse '#{@input_string}'\n" + 
#       "failure column: #{@parser.failure_column}\n" + 
#       "failure index: #{@parser.failure_index}\n" + 
#       "failure line: #{@parser.failure_line}\n" + 
#       "failure reason: #{@parser.failure_reason}\n" 
#     end 
#     def failure_message_for_should_not 
#       "expected #{@parser} not to parse '#{@input_string}'" 
#     end 
#     def description 
#       "parse `#{@input_string}'" 
#     end 
#   end 
#   def treetop_parse(input_string) 
#     ParserMatcher.new(input_string) 
#   end 
# end
# 
# module TrekGrammarParsingMatchers
#   class ShouldParse
#     def initialize(contents, parser)
#       @contents = contents
#       @parser = parser
#     end
#     
#     def matches?(contents)
#       string =
#       case @contents
#       when String
#         @contents
#       when File
#         raise "shit!"
#       end
#       
#       @parsed_value = @parser.parse(string)
#       
#       !@parsed_value.nil?
#     end
#     
#     def failure_message
#       "expected Parser to #{description} but it did not."
#     end
#     
#     def negative_failure_message
#       "expected Parser to not parse #{description} but got syntax tree: #{@parsed_value.inspect}"
#     end
#     
#     def description
#       case @contents
#       when String
#         "parse '#{@contents}'"
#       when File
#         "parse contents of file #{@contents}"
#       end
#     end
#   end
#   
#   
#   class ShouldCapture
#     def initialize(name, nodes)
#       @name = name
#       @nodes = nodes
#     end
#     
#     def matches?(contents)
#       captured_name? && captured_with_correct_value?
#     end
#     
#     def failure_message
#       "expected parser to capture #{@name.inspect}, but it did not"
#     end
#     
#     def negative_failure_message
#       message = "did not expect parser to capture #{@name.inspect}"
#       if captured_name?
#         message << ", but it captured as #{@nodes.send(@name).inspect}"
#       end
#       message
#     end
#     
#     def captured_name?
#       @nodes.respond_to?(@name)
#     end
#     
#     def captured_with_correct_value?
#       return true unless @value
#       @nodes.send(@name).text_value == @value
#     end
#     
#     def description
#       @description = "capture #{@name}"
#       if defined?(@value)
#         @description << " as '#{@value}'"
#       end
#       @description
#     end
#     
#     def as(value)
#       @value = value
#       self 
#     end
#   end
#   
#   def parse(contents)
#     ShouldParse.new(contents, @parser)
#   end
#   def capture(name_as_symbol)
#     ShouldCapture.new(name_as_symbol, @parsed)
#   end
# end
