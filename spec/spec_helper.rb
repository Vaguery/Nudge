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

