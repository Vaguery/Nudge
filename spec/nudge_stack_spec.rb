# encoding: UTF-8
require File.expand_path("../nudge", File.dirname(__FILE__))

describe "NudgeStack" do
  describe ".new" do
    it "sets @value_type" do
      NudgeStack.new(:mock).instance_variable_get(:@value_type).should == :mock
    end
  end
  
  describe "#<< (item: Object)" do
    it "calls #to_s on the item" do
      stack = NudgeStack.new(:mock)
      item = mock(:item)
      
      item.should_receive(:to_s)
      
      stack << item
    end
    
    it "adds item.to_s to the stack" do
      stack = NudgeStack.new(:mock)
      item = mock(:item)
      
      stack << item
      
      stack.last.should == item.to_s
    end
  end
  
  describe "#push" do
    it "raises NoMethodError" do
      stack = NudgeStack.new(:int)
      lambda { stack.push(9) }.should raise_error NoMethodError
    end
  end
  
  describe "#pop_string" do
    it "returns the top item on the stack as a string" do
      stack = NudgeStack.new(:mock)
      item = mock(:item)
      
      stack << item
      
      stack.pop_string.should == item.to_s
    end
    
    it "removes the top item from the stack" do
      stack = NudgeStack.new(:mock)
      
      stack << mock(:item)
      stack.pop_string
      
      stack.length.should == 0
    end
  end
  
  describe "#pop_value" do
    it "returns the top item on the stack after calling to_{value_type}" do
      stack = NudgeStack.new(:mock)
      item = mock(:item)
      string = mock(:string_item)
      
      item.stub!(:to_s).and_return(string)
      stack << item
      
      string.should_receive(:to_mock).and_return(item)
      
      stack.pop_value.should == item
    end
    
    it "removes the top item from the stack" do
      stack = NudgeStack.new(:mock)
      item = mock(:item)
      string = mock(:string_item)
      
      item.stub!(:to_s).and_return(string)
      string.stub!(:to_mock)
      
      stack << item
      stack.pop_value
      
      stack.length.should == 0
    end
  end
  
  describe "#pop" do
    it "raises NoMethodError" do
      stack = NudgeStack.new(:mock)
      lambda { stack.pop }.should raise_error NoMethodError
    end
  end
  
  describe "#shove (n: Integer)" do
    it "moves the top item on the stack down by n positions" do
      stack = NudgeStack.new(:mock)
      top = mock(:top)
      middle = mock(:middle)
      bottom = mock(:bottom)
      
      stack.concat [bottom, middle, top]
      stack.shove(1)
      
      stack[-1].should == middle
      stack[-2].should == top
      stack[-3].should == bottom
    end
    
    it "leaves stack unchanged when n is negative" do
      stack = NudgeStack.new(:mock)
      top = mock(:top)
      middle = mock(:middle)
      bottom = mock(:bottom)
      
      stack.concat [bottom, middle, top]
      stack.shove(-4)
      
      stack[-1].should == top
      stack[-2].should == middle
      stack[-3].should == bottom
    end
    
    it "moves the top item on the stack to the bottom when n is greater than stack depth" do
      stack = NudgeStack.new(:mock)
      top = mock(:top)
      middle = mock(:middle)
      bottom = mock(:bottom)
      
      stack.concat [bottom, middle, top]
      stack.shove(9)
      
      stack[-1].should == middle
      stack[-2].should == bottom
      stack[-3].should == top
    end
  end
  
  describe "#yank (n: Integer)" do
    it "moves the item at position n to the top of the stack" do
      stack = NudgeStack.new(:mock)
      top = mock(:top)
      middle = mock(:middle)
      bottom = mock(:bottom)
      
      stack.concat [bottom, middle, top]
      stack.yank(1)
      
      stack[-1].should == middle
      stack[-2].should == top
      stack[-3].should == bottom
    end
    
    it "leaves stack unchanged when n is negative" do
      stack = NudgeStack.new(:mock)
      top = mock(:top)
      middle = mock(:middle)
      bottom = mock(:bottom)
      
      stack.concat [bottom, middle, top]
      stack.yank(-4)
      
      stack[-1].should == top
      stack[-2].should == middle
      stack[-3].should == bottom
    end
    
    it "moves the bottom item on the stack to the top when n is greater than stack depth" do
      stack = NudgeStack.new(:mock)
      top = mock(:top)
      middle = mock(:middle)
      bottom = mock(:bottom)
      
      stack.concat [bottom, middle, top]
      stack.yank(9)
      
      stack[-1].should == bottom
      stack[-2].should == top
      stack[-3].should == middle
    end
  end
  
  describe "#yankdup (n: Integer)" do
    it "adds a duplicate of the item at position n to the top of the stack" do
      stack = NudgeStack.new(:mock)
      top = mock(:top)
      middle = mock(:middle)
      bottom = mock(:bottom)
      
      stack.concat [bottom, middle, top]
      stack.yankdup(1)
      
      stack[-1].should == middle
      stack[-2].should == top
      stack[-3].should == middle
      stack[-4].should == bottom
    end
    
    it "adds a duplicate of the top item to the top of the stack when n is negative" do
      stack = NudgeStack.new(:mock)
      top = mock(:top)
      middle = mock(:middle)
      bottom = mock(:bottom)
      
      stack.concat [bottom, middle, top]
      stack.yankdup(-4)
      
      stack[-1].should == top
      stack[-2].should == top
      stack[-3].should == middle
      stack[-4].should == bottom
    end
    
    it "adds a duplicate of the bottom item on the stack to the top when n is greater than stack depth" do
      stack = NudgeStack.new(:mock)
      top = mock(:top)
      middle = mock(:middle)
      bottom = mock(:bottom)
      
      stack.concat [bottom, middle, top]
      stack.yankdup(9)
      
      stack[-1].should == bottom
      stack[-2].should == top
      stack[-3].should == middle
      stack[-4].should == bottom
    end
  end
end

describe "ExecStack" do
  describe "#<< (item: NudgePoint)" do
    it "adds the item to the stack" do
      stack = ExecStack.new(:exec)
      item = NudgePoint.new
      
      stack << item
      
      stack.last.should == item
    end
  end
  
  describe "#pop_string" do
    it "raises NoMethodError" do
      stack = ExecStack.new(:exec)
      lambda { stack.pop_string }.should raise_error NoMethodError
    end
  end
  
  describe "#pop_value" do
    it "returns the top item on the stack" do
      stack = ExecStack.new(:exec)
      item = NudgePoint.new
      
      stack << item
      
      stack.pop_value.should == item
    end
    
    it "removes the top item from the stack" do
      stack = ExecStack.new(:exec)
      item = NudgePoint.new
      
      stack << item
      stack.pop_value
      
      stack.length.should == 0
    end
  end
end

describe "ErrorStack" do
  describe "#<< (error: NudgeError)" do
    it "adds a string representation of the error to the stack" do
      stack = ErrorStack.new(:error)
      
      begin
        raise NudgeError, "an error occurred"
      rescue => error
        stack << error
      end
      
      stack.last.should == "NudgeError: an error occurred"
    end
  end
  
  describe "#pop_value" do
    it "raises NoMethodError" do
      stack = ErrorStack.new(:error)
      lambda { stack.pop_value }.should raise_error NoMethodError
    end
  end
end
