# encoding: UTF-8
require File.expand_path("../nudge", File.dirname(__FILE__))

describe "NudgeExecutable" do
  describe ".new (script: String)" do
    it "sets @tree to NudgePoint.from(script)" do
      tree = NudgePoint.from("ref x")
      NudgePoint.stub!(:from).and_return(tree)
      
      exe = NudgeExecutable.new("ref x")
      
      exe.instance_variable_get(:@tree).should == tree
    end
    
    it "calls #set_options({}) on the new NudgeExecutable" do
      exe = NudgeExecutable.new("ref x")
      
      exe.should_receive(:set_options).with({})
      
      exe.send(:initialize, "ref x")
    end
    
    it "calls #bind({}) on the new NudgeExecutable" do
      exe = NudgeExecutable.new("ref x")
      
      exe.should_receive(:bind).with({})
      
      exe.send(:initialize, "ref x")
    end
  end
  
  
  describe "default options" do
    it "has a default point_limit of 3000" do
      NudgeExecutable.new("").instance_variable_get(:@point_limit).should == 3000
    end 
    
    it "has a default time_limit of 1" do
      NudgeExecutable.new("").instance_variable_get(:@time_limit).should == 1
    end
    
    it "has a default min_float of -100.0" do
      NudgeExecutable.new("").instance_variable_get(:@min_float).should == -100.0
    end
    
    it "has a default max_float of 100.0" do
      NudgeExecutable.new("").instance_variable_get(:@max_float).should == 100.0
    end
    
    it "has a default min_int of -100" do
      NudgeExecutable.new("").instance_variable_get(:@min_int).should == -100
    end
    
    it "has a default max_int of 100" do
      NudgeExecutable.new("").instance_variable_get(:@max_int).should == 100
    end
  end
  
  
  describe "#set_options (options: Hash)" do
    it "sets @point_limit" do
      exe = NudgeExecutable.new("ref x")
      exe.set_options(:point_limit => 1)
      
      exe.instance_variable_get(:@point_limit).should == 1
    end
    
    it "sets @time_limit" do
      exe = NudgeExecutable.new("ref x")
      exe.set_options(:time_limit => 5)
      
      exe.instance_variable_get(:@time_limit).should == 5
    end
    
    it "sets @min_float" do
      exe = NudgeExecutable.new("ref x")
      exe.set_options(:float_range => 5.1..10.2)
      
      exe.instance_variable_get(:@min_float).should == 5.1
    end
    
    it "sets @max_float" do
      exe = NudgeExecutable.new("ref x")
      exe.set_options(:float_range => 5.1..10.1)
      
      exe.instance_variable_get(:@max_float).should == 10.1
    end
    
    it "sets @min_int" do
      exe = NudgeExecutable.new("ref x")
      exe.set_options(:int_range => 5..10)
      
      exe.instance_variable_get(:@min_int).should == 5
    end
    
    it "sets @max_int" do
      exe = NudgeExecutable.new("ref x")
      exe.set_options(:int_range => 5..10)
      
      exe.instance_variable_get(:@max_int).should == 10
    end
  end
  
  describe "#bind (variable_bindings: Hash)" do
    it "sets @variable_bindings" do
      exe = NudgeExecutable.new("ref x")
      variable_bindings = {:x => Value.new(:int, 100)}
      
      exe.bind(variable_bindings)
      
      exe.instance_variable_get(:@variable_bindings).should == variable_bindings
    end
    
    it "calls #reset on the NudgeExecutable" do
      exe = NudgeExecutable.new("ref x")
      variable_bindings = {:x => Value.new(:int, 100)}
      
      exe.should_receive(:reset)
      
      exe.bind(variable_bindings)
    end
  end
  
  describe "#reset" do
    it "sets @points_evaluated to 0" do
      exe = NudgeExecutable.new("ref x")
      exe.reset
      
      exe.instance_variable_get(:@points_evaluated).should == 0
    end
    
    it "sets @time_elapsed to 0" do
      exe = NudgeExecutable.new("ref x")
      exe.reset
      
      exe.instance_variable_get(:@time_elapsed).should == 0
    end
    
    it "sets @allow_lookup to true" do
      exe = NudgeExecutable.new("ref x")
      exe.reset
      
      exe.instance_variable_get(:@allow_lookup).should == true
    end
    
    it "sets @stacks to a new hash" do
      exe = NudgeExecutable.new("ref x")
      exe.reset
      
      exe.instance_variable_get(:@stacks).should be_a Hash
    end
    
    it "sets @stacks[:error] to an ErrorStack" do
      exe = NudgeExecutable.new("ref x")
      exe.reset
      
      exe.instance_variable_get(:@stacks)[:error].should be_an ErrorStack
    end
    
    it "sets @stacks[:exec] to an ExecStack" do
      exe = NudgeExecutable.new("ref x")
      exe.reset
      
      exe.instance_variable_get(:@stacks)[:exec].should be_an ExecStack
    end
    
    it "pushes @tree onto the :exec stack" do
      exe = NudgeExecutable.new("ref x")
      tree = exe.instance_variable_get(:@tree)
      
      exe.reset
      
      exe.instance_variable_get(:@stacks)[:exec].last.should == tree
    end
  end
  
  describe "#step" do
    it "evaluates the top item on the :exec stack" do
      exe = NudgeExecutable.new("ref x")
      top_item = exe.stacks[:exec][-1]
      
      top_item.should_receive(:evaluate)
      
      exe.step
    end
    
    it "pops the top item from the :exec stack" do
      exe = NudgeExecutable.new("ref x")
      top_item = exe.stacks[:exec][-1]
      stack = exe.stacks[:exec]
      
      stack.should_receive(:pop_value).and_return(top_item)
      
      exe.step
    end
    
    it "increments @points_evaluated by one" do
      exe = NudgeExecutable.new("ref x")
      points_evaluated = exe.instance_variable_get(:@points_evaluated)
      
      exe.step
      
      exe.instance_variable_get(:@points_evaluated).should == points_evaluated + 1
    end
    
    it "increases @time_elapsed" do
      exe = NudgeExecutable.new("ref x")
      time_elapsed = exe.instance_variable_get(:@time_elapsed)
      
      exe.step
      
      exe.instance_variable_get(:@time_elapsed).should > time_elapsed
    end
    
    it "pushes an item onto the :error stack if point evaluation raises a NudgeError" do
      exe = NudgeExecutable.new("do x")
      
      exe.stacks[:error].should_receive(:push).with("UnknownInstruction: x not recognized")
      
      exe.step
    end
  end
  
  describe "#step (n: Integer)" do
    it "repeats the #step process n times" do
      exe = NudgeExecutable.new("block { ref x ref x ref x ref x ref x }")
      
      exe.step(3)
      
      exe.instance_variable_get(:@points_evaluated).should == 3
    end
    
    it "stops stepping if the exec stack is empty" do
      exe = NudgeExecutable.new("ref x")
      
      exe.step(3)
      
      exe.instance_variable_get(:@points_evaluated).should == 1
    end
  end
  
  describe "#run" do
    it "pops and evaluates points until the :exec stack is empty" do
      exe = NudgeExecutable.new("block { ref x ref x ref x }")
      
      exe.run
      
      exe.stacks[:exec].length.should == 0
      exe.stacks[:name].length.should == 3
    end
    
    it "stops when @points_evaluated reaches @point_limit" do
      exe = NudgeExecutable.new("block { block {} block {} block {} }")
      exe.instance_variable_set(:@points_evaluated, 2997)
      
      exe.run
      
      exe.instance_variable_get(:@points_evaluated).should == exe.instance_variable_get(:@point_limit)
    end
    
    it "stops after @time_elapsed reaches @time_limit" do
      exe = NudgeExecutable.new("block { do exec_y ref x }")
      exe.instance_variable_set(:@time_elapsed, 0.999)
      
      exe.run
      
      exe.instance_variable_get(:@time_elapsed).floor.should == exe.instance_variable_get(:@time_limit)
    end
  end
  
  describe "#lookup_allowed?" do
    it "sets @allow_lookup to true" do
      exe = NudgeExecutable.new("ref x")
      exe.instance_variable_set(:@allow_lookup, false)
      
      exe.lookup_allowed?
      
      exe.instance_variable_get(:@allow_lookup).should == true
    end
    
    it "returns the previous value of @allow_lookup" do
      exe = NudgeExecutable.new("ref x")
      exe.instance_variable_set(:@allow_lookup, false)
      
      exe.lookup_allowed?.should == false
    end
  end
  
  describe "#points_evaluated" do
    it "returns @points_evaluated" do
      exe = NudgeExecutable.new("ref x")
      exe.points_evaluated.should == exe.instance_variable_get(:@points_evaluated)
    end
  end
  
  describe "#stacks" do
    it "returns @stacks" do
      exe = NudgeExecutable.new("ref x")
      exe.stacks.should == exe.instance_variable_get(:@stacks)
    end
  end
  
  describe "#time_elapsed" do
    it "returns @time_elapsed" do
      exe = NudgeExecutable.new("ref x")
      exe.time_elapsed.should == exe.instance_variable_get(:@time_elapsed)
    end
  end
  
  describe "#variable_bindings" do
    it "returns @variable_bindings" do
      exe = NudgeExecutable.new("ref x")
      exe.variable_bindings.should == exe.instance_variable_get(:@variable_bindings)
    end
  end
end
