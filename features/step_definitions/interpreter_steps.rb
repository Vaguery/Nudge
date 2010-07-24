#encoding: utf-8
Before do
  @context = Outcome.new({})
end

Given /^the blueprint "([^"]*)"$/ do |arg1|
  @feature_blueprint = arg1
end

When /^I take one execution step$/ do
  @context.stacks[:exec].pop.evaluate(@context.begin)
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
