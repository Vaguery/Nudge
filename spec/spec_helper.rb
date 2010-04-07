#encoding: utf-8
$: << File.join(File.dirname(__FILE__), "/../lib") 


require 'spec'
require 'pp'
require 'lib/nudge'
require 'erb'

Spec::Runner.configure do |config|
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure 
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

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
end