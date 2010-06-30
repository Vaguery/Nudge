Given /^I have placed "([^"]*)" on the "([^"]*)" stack$/ do |value, stack|
  @context = Outcome.new({})
  @context.stacks[stack.intern] << value
end

When /^I execute the Nudge instruction "([^"]*)"$/ do |arg1|
  puts NudgeInstruction.INSTRUCTIONS.inspect
end

Then /^"([^"]*)" should be on top of the "([^"]*)" stack$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then /^the argument should be gone$/ do
  pending # express the regexp above with the code you wish you had
end
