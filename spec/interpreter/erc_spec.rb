require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "erc" do
  
  it "should be a kind of Leaf" do
    lit = Erc.new(:char, "a")
    lit.should be_a_kind_of(Leaf)
  end
  
  
  describe "initialization" do
    it "should be created with a default randomizer that returns current value" do
      noRand = Erc.new(:int, 13)
      noRand.randomize
      noRand.value.should == 13
    end
  end
  
  describe "randomization" do
    it "should allow you to set a new randomizer" do
      erc = Erc.new(:int, 13)
      newR = lambda {88}
      erc.randomizer = newR
      erc.randomizer.should == newR
    end

    
    it "should demand the randomizer is a Proc object that returns a value" do
      incRand = Erc.new(:int, -3)
      lambda {incRand.randomizer = "bad string"}.should raise_error(TypeError, "A randomizer must be a lambda or Proc object")
    end
    
    
    it "should invoke the attribute's randomizer code when Erc#randomize is called" do
      incRand = Erc.new(:int, -3)
      incRand.randomizer = lambda {value + 1}
      incRand.randomize
      incRand.value.should == -2
      incRand.randomizer = lambda {(value*value)-value+1}
      incRand.randomize
      incRand.value.should == 7
      incRand.randomize
      incRand.value.should == 43
    end
    
    
    it "should be possible to temporarily override the randomize code with a block" do
      incRand = Erc.new(:int, 0)
      incRand.randomizer = lambda {value + 1}
      incRand.randomize
      incRand.value.should == 1
      incRand.randomize {888}
      incRand.value.should == 888
      incRand.randomize {value - 88}
      incRand.value.should == 800
      # and revert when no block is given
      incRand.randomize
      incRand.value.should == 801
    end
    
  end
  
  describe "converting to a literal" do
    it "should allow you to cast it to a Literal with the same values" do
      transient = Erc.new(:string, "gosh")
      fixed = transient.to_literal
      fixed.should be_a_kind_of(Literal)
      fixed.value.should == "gosh"
      fixed.stackname.should == :string
    end
  end
  
  describe "inspection" do
    it "should print 'ERC(value,type) for Erc#inspect" do
      fixed = Erc.new(:string, "aString")
      fixed.inspect.should == 'ERC(:string,"aString")'
      complex = Erc.new(:tree, [1,2,[3,4]])
      complex.inspect.should == 'ERC(:tree,'+[1,2,[3,4]].inspect+')'
    end
  end
  
end