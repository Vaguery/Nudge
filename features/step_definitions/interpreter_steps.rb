#encoding: utf-8
Before do
  @context = NudgeExecutable.new("")
end

Given /^the blueprint "([^"]*)"$/ do |script|
  @feature_blueprint = script
end


Given /^I have bound "([^"]*)" to an :([^"]*) with value "([^"]*)"$/ do |name, type, value|
  @context.variable_bindings[name.to_sym] = Value.new(type.to_sym, value)
end


Given /^the execution counter is set to (\d+)$/ do |steps|
  @context.points_evaluated = steps.to_i
end


Given /^the execution limit is set to (\d+)$/ do |limit|
  Outcome::POINT_LIMIT = limit.to_i
end


Given /^I have pushed an instruction called "([^"]*)" onto the :exec stack$/ do |inst|
  @context.stacks[:exec] = [DoPoint.new(inst)]
end


When /^I take one execution step$/ do
  @context.step
end


When /^I run the interpreter$/ do
  e = NudgeExecutable.new(@feature_blueprint)
  @context = e.run
  puts @context.stacks.inspect
end


When /^I parse that blueprint$/ do
  @feature_tree = NudgePoint.from(@feature_blueprint)
end


Then /^the result should be a NilPoint$/ do
  @feature_tree.should be_a_kind_of(NilPoint)
end


Then /^its script should be "([^"]*)"$/ do |script|
  @feature_tree.to_script.should == script
end

Then /^the number of points should be (\d+)$/ do |number|
  @feature_tree.points.should == number.to_i
end

Then /^the execution counter should be (\d+)$/ do |steps|
  @context.points_evaluated.should == steps.to_i
end
