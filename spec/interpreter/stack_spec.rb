#encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "stack" do
  before(:each) do
    @myStack = Stack.new(:int)
  end
  
  describe "initialization" do
    it "should have a name" do
      @myStack.name.should == :int
    end
    
    it "should only accept a symbol as a name" do
      lambda{ Stack.new("hi")}.should raise_error(ArgumentError,"Stack name must be a Symbol")
      lambda{ Stack.new(88)}.should raise_error(ArgumentError)
      lambda{ Stack.new(:caprica)}.should_not raise_error
    end

    it "should have no entries" do
      @myStack.entries.should have(0).items
    end
  end
  
  
  describe "pushing and popping" do
    it "should allow any object to be pushed" do
      @myStack.push(12)
      @myStack.entries[0].should == 12
    end
    
    it "should grow by one when an item is pushed" do
      @myStack.push(1)
      @myStack.push(2)
      @myStack.push(3)
      @myStack.entries.should have(3).items
    end
    
    it "should ignore attempts to push nil" do
      @myStack.push(nil)
      @myStack.entries.should have(0).items
    end
    
    it "should return its top item when popping" do
      @myStack.push('hello')
      fellOff = @myStack.pop
      fellOff.should == 'hello'
      @myStack.entries.should have(0).items
    end
    
    it "should fail silently if popped when empty, returning nil" do
      empty = @myStack.pop
      empty.should == nil
      @myStack.entries.should have(0).items
    end
  end
  
  describe "peeking" do
    it "should return but not pop the last item on the stack" do
      @myStack.push(1)
      @myStack.peek.should == 1
      @myStack.push(2)
      @myStack.peek.should == 2
      @myStack.push(3)
      @myStack.peek.should == 3
    end
    
    it "should fail silently if popped when empty, returning nil" do
      @myStack.peek.should == nil
    end
  end
  
  describe "depth" do
    it "should return the number of items" do
      @myStack.depth.should == 0
      @myStack.push(1)
      @myStack.push(2)
      @myStack.depth.should == 2
    end
  end
  
  
  describe "inspect" do
    it "should return the entries wrapped in brackets" do
      inspectable_me = Stack.new(:foo)
      3.times {inspectable_me.push(ValuePoint.new("foo", rand(1000)))}
      inspectable_me.inspect.first.should == "["
      inspectable_me.inspect.last.should == "]"
    end
    
    it "should return them top-to-bottom" do
      inspectable_me = Stack.new(:foo)
      inspectable_me.push(ValuePoint.new("foo", 'bottom'))
      inspectable_me.push(ValuePoint.new("foo", 'top'))
      inspectable_me.inspect.should =~ /(.+)top(.+)bottom\]/um
    end
    
    it "should return a string containing every entry" do
      inspectable_me = Stack.new(:foo)
      (-2..2).each {|i| inspectable_me.push(ValuePoint.new("foo", i))}
      (inspectable_me.inspect.scan(/(-\d|\d)/)).flatten.collect {|n| n.to_i}.should ==
        [2,1,0,-1,-2]
    end
    
    it "should return the type and value of each entry" do
      inspectable_me = Stack.new(:foo)
      inspectable_me.push(ValuePoint.new("a", '1'))
      inspectable_me.push(ValuePoint.new("b", '2'))
      inspectable_me.push(ValuePoint.new("c", '3'))
      inspectable_me.push(ValuePoint.new("d", '4'))
      
      inspectable_me.inspect.should == "[\n«d» 4,\n«c» 3,\n«b» 2,\n«a» 1]"
    end
  end
end