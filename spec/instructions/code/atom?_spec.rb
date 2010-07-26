# encoding: UTF-8
require 'spec_helper'


describe "CodeAtomQ" do
  before(:each) do
    @context = Outcome.new({})
  end
  
  
  describe "needs" do
    it "needs 1 :code items" do
      CodeAtomQ::REQUIREMENTS.should == {code:1}
    end
  end
  
  
  describe "#process()" do
    # this seems kludgy because :&& can't be mocked (?)
    it "pushes 'false' to :bool if the item is a BlockPoint" do
      @context.stacks[:code] << "block{ref a}"
      CodeAtomQ.new(@context).execute
      @context.stacks[:bool].should == ["false"]
    end
    
    it "pushes 'false' to :bool if the item is gibberish" do
      @context.stacks[:code] << "can't stop now"
      CodeAtomQ.new(@context).execute
      @context.stacks[:bool].should == ["false"]
    end
    
    it "pushes 'true' to :bool if the item is a ref" do
      @context.stacks[:code] << "ref x"
      CodeAtomQ.new(@context).execute
      @context.stacks[:bool].should == ["true"]
    end
    
    it "pushes 'true' to :bool if the item is an instruction" do
      @context.stacks[:code] << "do foo"
      CodeAtomQ.new(@context).execute
      @context.stacks[:bool].should == ["true"]
    end
    
    it "pushes 'true' to :bool if the item is a value" do
      @context.stacks[:code] << "value «foo»\n«foo» bar"
      CodeAtomQ.new(@context).execute
      @context.stacks[:bool].should == ["true"]
    end
    
    
  end
end
