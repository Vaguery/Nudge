require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "PointMutationOperator" do
  describe "initialization" do
    it "should have a params attribute when created that sets basic values for code generation" do
      PointMutationOperator.new.params.should == {}
      mutator = PointMutationOperator.new(:points => 3, :blocks => 1)
      mutator.params.should_not == {}
      mutator.params[:points].should == 3
    end
  end
  
  describe "generate" do
    before(:each) do
      @gammaray = PointMutationOperator.new(:points => 3, :types => [IntType])
      @dude1 = Individual.new("block { do x1 \n do x2 \n do x3}")
    end
    
    it "should accept an Array of one or more Individuals as a param" do
      lambda{@gammaray.generate()}.should raise_error(ArgumentError)
      lambda{@gammaray.generate(99)}.should raise_error(ArgumentError)
      lambda{@gammaray.generate([])}.should raise_error(ArgumentError)
      lambda{@gammaray.generate([99])}.should raise_error(ArgumentError)
      
      lambda{@gammaray.generate([@dude1])}.should_not raise_error(ArgumentError)
    end
    
    it "should return an array as a result" do
      @gammaray.generate([@dude1]).should be_a_kind_of(Array)
    end
    
    it "should use Individual#replace_point to produce the variants" do
      @dude1.should_receive(:replace_point).and_return("do anything")
      @gammaray.generate([@dude1])
    end
    
    it "should produce one result per individual in the wildtype crowd as a default" do
      @gammaray.generate([@dude1]).length.should == 1
      @gammaray.generate([@dude1,@dude1]).length.should == 2
    end
    
    it "should produce more if passed the optional howManyCopies parameter > 1" do
      @gammaray.generate([@dude1],3).length.should == 3
      @gammaray.generate([@dude1,@dude1],2).length.should == 4
    end
    
    it "should produce individuals from which a random point (and all subpoints) is replaced" do
      @gammaray.should_receive(:rand).and_return(0)
      @gammaray.generate([@dude1])[0].points.should == 3 # totally replaced with 3-pt code
      @gammaray.should_receive(:rand).and_return(1)
      @gammaray.generate([@dude1])[0].points.should == 6 #replace point 2 with 3-pt code
      @gammaray.should_receive(:rand).and_return(2)
      @gammaray.generate([@dude1])[0].points.should == 6 #replace point 3 with 3-pt code
      @gammaray.should_receive(:rand).and_return(3)
      @gammaray.generate([@dude1])[0].points.should == 6 #replace point 4 with 3-pt code
    end
    
    it "should accept temporarily overriding params to pass into CodeType.random_value" do
      @gammaray.should_receive(:rand).and_return(0)
      @gammaray.generate([@dude1])[0].points.should == 3 # totally replaced with 3-pt code
      @gammaray.should_receive(:rand).and_return(0)
      @gammaray.generate([@dude1],1,:points => 10)[0].points.should == 10
    end
    
    it "should increment the #progress of the offspring" do
      @dude1.progress = 888
      @gammaray.generate([@dude1],13).each {|baby| baby.progress.should == 889}
    end
  end
end