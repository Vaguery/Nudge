#encoding: utf-8
require 'stringio'
require 'spec/stubs/cucumber'

Before do
  @context = NudgeExecutable.new("")
  @context.stacks[:exec].pop_value # makes the stack empty
  @mistakes = StringIO.open('','r+')
  $stderr = @mistakes
end

After do
  $stderr = STDERR
end

Given /^I have pushed "([^"]*)" onto the bool stack$/ do |value|
  @context.stacks[:bool] << value
end

Given /^I have noted the object_id of the item in position (\-*\d+) of stack :([a-z\d_]+)$/ do |pos, stack|
  @stored_object_id = @context.stacks[stack.intern][pos.to_i].object_id
end


Given /^I have pushed "([^"]*)" onto the :([a-z\d_]+) stack$/ do |string, stack|
  string.gsub!('\n',"\n")
  string.gsub!('\t',"\t")
  if stack == "exec"
    @context.stacks[:exec] << NudgePoint.from(string)
  else
    @context.stacks[stack.intern] << string
  end
end


Given /^"([^"]*)" is bound to a :([a-z\d_]+) with value "([^"]*)"$/ do |var_name, type, value|
  @context.variable_bindings[var_name.intern] = Value.new(type.intern,value)
end



When /^I execute the Nudge instruction "([^"]*)"$/ do |instruction_name|
  @context.stacks[:exec] << DoPoint.new(instruction_name.intern)
  @context.step
end


Then /^"([^"]*)" should be in position (-?\d+) of the :([a-z\d_]+) stack$/ do |result_val, posn, stack|
  result_val.gsub!('\n',"\n")
  result_val.gsub!('\t',"\t")
  unless result_val.strip == ""
    @output_stack = @context.stacks[stack.intern]
    if stack == "exec"
      @output_stack[posn].to_script.should == NudgePoint.from(result_val).to_script
    elsif stack == "code"
      NudgePoint.from(@output_stack[posn]).to_script.should == NudgePoint.from(result_val).to_script
    else
      @output_stack[posn].should == result_val
    end
  else
    @context.stacks[stack.intern].length.should == 0
  end
end


Then /^something close to "([^"]*)" should be in position (-?\d+) of the :([a-z\d_]+) stack$/ do |result_val, posn, stack|
  unless result_val.strip == ""
    float_value = @context.stacks[stack.intern][posn]
    if float_value.nil?
      fail
    else
      float_value.to_f.should be_close(result_val.to_f,0.0001)
    end
  else
    @context.stacks[stack.intern].length.should == 0
  end
end


Then /^"([^"]*)" should be on top of the bool stack$/ do |result_val|
  @context.stacks[:bool][0].should == result_val
end


Then /^stack :([a-z\d_]+) should have depth ([\d]+)$/  do |stack, depth|
  @context.stacks[stack.intern].depth.should == depth.to_i
end



Then /^no warning message should be produced$/ do
  @mistakes.rewind
  @mistakes.read.should == ""
end


Then /^the top :error should include "([^"]*)"/ do |message|
  if message.strip == ""
    @context.stacks[:error].length.should == 0
  else
    @context.stacks[:error][0].should include(message)
  end
end

Then /^the :error stack should not include "([^"]*)"/ do |phrase|
  @context.stacks[:error].count {|err| err.include?(phrase)}.should == 0
end



Then /^the object_id of the item bound to name "([^"]*)" should not be identical to the original$/ do |name|
  @context.variable_bindings[name.intern].should_not == @stored_object_id
end


Then /^stack :([a-z\d_]+) should include "([^"]*)"$/ do |stack, value|
  @context.stacks[stack.intern].should include(value)
end


Then /^the proportion of "([^"]*)" on the :([a-z\d_]+) stack should fall between ([0-9.]+) and ([0-9.]+)$/ do |outcome, stack, lower_bound, upper_bound|
  stack_of_interest = @context.stacks[stack.intern]
  (lower_bound.to_f..upper_bound.to_f).should include(
    stack_of_interest.count(outcome)/stack_of_interest.length.to_f)
end


Then /^the proportion of values less than ([0-9.]+) on the :([a-z\d_]+) stack should fall between ([0-9.]+) and ([0-9.]+)$/ do |cutoff, stack, lower_bound, upper_bound|
  count = @context.stacks[stack.intern].count {|v| v.to_f < cutoff.to_f}
  (lower_bound.to_f..upper_bound.to_f).should include(count/@context.stacks[stack.intern].length.to_f)
end



Then /^the :([a-z\d_]+) stack should be (\[(?:"[^"]*",? ?)+\])$/ do |stack, stack_image|
  if stack == "exec"
    @context.stacks[stack.intern].collect {|item| item.to_script.strip}.inspect.should == stack_image
  else
    @context.stacks[stack.intern].inspect.should == stack_image
  end
end


Then /^the block in position (\-*\d+) of the :exec stack should not contain the object on position (\-*\d+)$/ do |pos1, pos2|
  id1 = @context.stacks[:exec][pos2.to_i].object_id
  macro = @context.stacks[:exec][pos1.to_i]
  macro.instance_variable_get(:@points).collect {|pt| pt.object_id}.should_not include(id1)
end


Then /^name "([^"]*)" should be bound to "([^"]*)"$/ do |name, value|
  bound_value = @context.variable_bindings[name.intern]
  type = bound_value.instance_variable_get(:@value_type)
  
  if type == :exec
    bound_value.instance_variable_get(:@value).to_script.should == NudgePoint.from(value).to_script
  else
    bound_value.instance_variable_get(:@value).should == value
  end
end


Then /^there should be no repeated object_ids in the :exec stack$/ do
  unique_ids = @context.stacks[:exec].collect {|item| item.object_id}.uniq
  @context.stacks[:exec].length.should == unique_ids.length
end



