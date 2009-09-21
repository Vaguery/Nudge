require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Stack class" do
  
  after(:each) do
    Stack.cleanup
  end
  
  it "should keep have an empty stacks attribute, empty to begin" do
    Stack.stacks.should == {}
  end
  
  it "should include a new stack when a new Stack instance is made" do
    @ss = Stack.new(:boo)
    Stack.stacks.should include(:boo)
  end
end

describe "stack" do
  before(:each) do
    @myStack = Stack.new(:int)
  end
  
  
  describe "initialization" do
    it "should have a name" do
      @myStack.name.should == :int
    end

    it "should have no entries" do
      @myStack.entries.should have(0).items
    end
  end
  
  
  describe "pushing and popping" do
    it "should allow an object to be pushed" do
      @myStack.push(12)
      @myStack.entries[0].should == 12
    end
    
    it "should grow by one when an item is pushed" do
      @myStack.push(1)
      @myStack.push(2)
      @myStack.push(3)
      @myStack.entries.should have(3).items
    end
    
    it "should return its top item when popping" do
      @myStack.push('hello')
      fellOff = @myStack.pop
      fellOff.should == 'hello'
      @myStack.entries.should have(0).items
    end
    
    it "should fail silently if popped when empty" do
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
  end
  
  describe "depth" do
    it "should return the number of items" do
      @myStack.depth.should == 0
      @myStack.push(1)
      @myStack.push(2)
      @myStack.depth.should == 2
    end
  end
end