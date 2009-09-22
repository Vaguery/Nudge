require File.join(File.dirname(__FILE__), "./infrastructure.rb")
require 'singleton'


class IntAddInstruction
  include Singleton
  
  def setup
  end
  
  def call
  end
  
  def teardown
  end
end