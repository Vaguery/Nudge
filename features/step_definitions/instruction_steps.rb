Given /^I have pushed "([^"]*)" onto the :([a-z\d_]+) stack$/ do |value, stack|
  @context = Outcome.new({})
  @context.stacks[stack.intern] << value
end


When /^I execute the Nudge instruction "([^"]*)"$/ do |instruction_name|
  NudgePoint.from("do #{instruction_name}").evaluate(@context)
end

Then /^"([^"]*)" should be in position ([^"]*) of the "([^"]*)" stack$/ do |result_val, posn, stack|
  @output_stack = @context.stacks[stack.intern]
  @output_stack[posn].should == result_val
end

Then /^"([^"]*)" should be in position (\d+) of the :([a-z\d_]+) stack$/ do |result_val, posn, stack|
  @output_stack = @context.stacks[stack.intern]
  @output_stack[posn].should == result_val
end

Then /^that stack's depth should be (\d+)$/ do |depth|
  @output_stack.depth.should == depth
end
