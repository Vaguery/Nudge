$: << File.join(File.dirname(__FILE__), "/../lib") 

require 'rubygems' 
require 'spec'
require 'pp'
require 'nudge'

def fixture(name)
  File.read(File.join(File.dirname(__FILE__), "/fixtures/#{name}.example"))
end