# encoding: UTF-8
require 'spec_helper'


describe "NameUnbind" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = NameUnbind.new(@context)
  end
  
  describe "arguments" do
    it "should need one :name" do
      NameUnbind::REQUIREMENTS.should == {name:1}
    end
  end
  
  describe "#process" do
    it "should remove a binding if it exists" do
      @context.bind(x:Value.new(:int, 100))
      @context.stacks[:name] << "x"
      @inst.execute
      @context.variable_bindings[:x].should == nil
    end
    
    it "should remove the name from the keys" do
      @context.bind(x:Value.new(:int, 100))
      @context.stacks[:name] << "x"
      @inst.execute
      @context.variable_bindings.keys.should_not include(:x)
    end
  end
end
