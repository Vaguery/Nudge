require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

shared_examples_for "Any Int" do
  describe "IntLiteral#build method" do
    it "should accept one string parameter (of some sort) that is munged into the actual value" do
      IntLiteral.new.build("3").should == 3
      lambda{IntLiteral.new.build()}.should raise_error
    end
  end
end
describe "IntErc" do
  it_should_behave_like "Any Int"
end

shared_examples_for "Any Bool" do
  describe "BoolLiteral#build method" do
    it "should accept one string parameter (of some sort) that is munged into the actual value" do
      BoolLiteral.new.build("false").should == false
      lambda{BoolLiteral.new.build()}.should raise_error
    end
  end
end
describe "BoolErc" do
  it_should_behave_like "Any Bool"
end

shared_examples_for "Any Float" do
  describe "FloatLiteral#build method" do
    it "should accept one string parameter (of some sort) that is munged into the actual value" do
      FloatLiteral.new.build("3.331").should == 3.331
      lambda{FloatLiteral.new.build()}.should raise_error
    end
  end
end
describe "FloatErc" do
  it_should_behave_like "Any Float"
end