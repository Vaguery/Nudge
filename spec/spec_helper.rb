#encoding: utf-8
$: << File.join(File.dirname(__FILE__), "/../lib") 


require 'spec'
require 'interpreter/treetophelpers'
require 'pp'
require 'nudge'
require 'erb'

# include TreetopParserMatchers
# include TrekGrammarParsingMatchers

def fixture(name, data = binding)
  text = File.read(File.join(File.dirname(__FILE__), "/fixtures/#{name}.example"))
  ERB.new(text).result(data)
end

def load_grammar(name)
  Treetop.load(File.join(File.dirname(__FILE__), '..',
    'lib', 'interpreter', 'grammars', "nudge_#{name}.treetop"))
end


shared_examples_for "every Nudge Instruction" do
  
  it "should respond to \#preconditions?" do
    @i1.should respond_to(:preconditions?)
  end
  
  it "should respond to \#setup" do
    @i1.should respond_to(:setup)
  end   
  
  it "should respond to \#derive" do
    @i1.should respond_to(:derive)
  end   
  
  it "should respond to \#celanup" do
    @i1.should respond_to(:cleanup)
  end   
end
