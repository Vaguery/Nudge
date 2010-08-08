# encoding: UTF-8
require 'spec_helper'


describe "NameDisableLookup" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = NameDisableLookup.new(@context)
  end
  
  describe "arguments" do
    it "should need no args" do
      NameDisableLookup::REQUIREMENTS.should == {}
    end
  end
  
  describe "#process" do
    it "should set the context's @allow_lookup attribute to false" do
      @context.instance_variable_get(:@allow_lookup).should == true
      @inst.execute
      @context.instance_variable_get(:@allow_lookup).should == false
    end
    
    it "should not toggle it" do
      @context.instance_variable_get(:@allow_lookup).should == true
      @inst.execute
      @inst.execute
      @context.instance_variable_get(:@allow_lookup).should == false
    end    
  end
end
