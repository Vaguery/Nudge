#encoding: utf-8
$: << File.join(File.dirname(__FILE__), "/../lib") 


require 'spec'
require 'interpreter/treetophelpers'
require 'pp'
require 'nudge'
require 'erb'

include TreetopParserMatchers
include TrekGrammarParsingMatchers

def fixture(name, data = binding)
  text = File.read(File.join(File.dirname(__FILE__), "/fixtures/#{name}.example"))
  ERB.new(text).result(data)
end

def load_grammar(name)
  Treetop.load(File.join(File.dirname(__FILE__), '..',
    'lib', 'interpreter', 'grammars', "nudge_#{name}.treetop"))
end
