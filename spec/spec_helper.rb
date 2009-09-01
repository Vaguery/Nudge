$: << File.join(File.dirname(__FILE__), "/../lib") 

require 'rubygems' 
require 'spec'
require 'pp'
require 'nudge'
require 'erb'

def fixture(name, data = binding)
  text = File.read(File.join(File.dirname(__FILE__), "/fixtures/#{name}.example"))
  ERB.new(text).result(data)
end