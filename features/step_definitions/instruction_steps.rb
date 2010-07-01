Before do
  @context = Outcome.new({})
end

Given /^I have pushed "([^"]*)" onto the :([a-z\d_]+) stack$/ do |value, stack|
  @context.stacks[stack.intern] << value
end


When /^I execute the Nudge instruction "([^"]*)"$/ do |instruction_name|
  actor = NudgeInstruction.execute(instruction_name.intern, @context)
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
  @output_stack.length.should == depth.to_i
end
