#encoding: utf-8
Before do
  @context = Outcome.new({})
end

Given /^I have pushed "([^"]*)" onto the bool stack$/ do |value|
  @context.stacks[:bool] << value
end



Given /^I have pushed "([^"]*)" onto the :([a-z\d_]+) stack$/ do |value, stack|
  unless stack == "exec"
    @context.stacks[stack.intern] << value
  else
    @context.stacks[:exec] << NudgePoint.from(value)
  end
end


When /^I execute the Nudge instruction "([^"]*)"$/ do |instruction_name|
  actor = NudgeInstruction.execute(instruction_name.intern, @context)
end


Then /^"([^"]*)" should be in position ([^"]*) of the "([^"]*)" stack$/ do |result_val, posn, stack|
  @output_stack = @context.stacks[stack.intern]
  @output_stack[posn].should == result_val
end


Then /^"([^"]*)" should be in position (\d+) of the :([a-z\d_]+) stack$/ do |result_val, posn, stack|
  unless result_val.strip == ""
    @output_stack = @context.stacks[stack.intern]
    @output_stack[posn].should == result_val
  else
    @context.stacks[stack.intern].length.should == 0
  end
end


Then /^"([^"]*)" should be on top of the bool stack$/ do |result_val|
  @context.stacks[:bool][0].should == result_val
end


Then /^stack :([a-z\d_]+) should have depth ([\d]+)$/  do |stack, depth|
  @context.stacks[stack.intern].length.should == depth.to_i
end


Then /^that stack's depth should be (\d+)$/ do |depth|
  @output_stack.length.should == depth.to_i
end

Then /^the top :error should include "([^"]*)"/ do |message|
  if message.strip == ""
    @context.stacks[:error].length.should == 0
  else
    @context.stacks[:error][0].should include(message)
  end
end