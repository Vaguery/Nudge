#encoding: utf-8

Given /^the blueprint "([^"]*)"$/ do |script|
  @context.stacks[:exec] << NudgePoint.from(script)
end


Given /^I have bound "([^"]*)" to an :([^"]*) with value "([^"]*)"$/ do |name, type, value|
  @context.variable_bindings[name.to_sym] = Value.new(type.to_sym, value)
end


Given /^the execution counter is set to (\d+)$/ do |steps|
  @context.instance_variable_set(:@points_evaluated, steps.to_i)
end


Given /^I have set the Interpreter's termination point_limit to (\d+)$/ do |limit|
  @context.instance_variable_set(:@point_limit, limit.to_i)
end

Given /^I have set the Interpreter's termination time_limit to (\d+)$/ do |limit|
  @context.instance_variable_set(:@time_limit,limit.to_i)
end

Given /^I have set the Interpreter's min_int to (\d+)$/ do |lower|
  @context.instance_variable_set(:@min_int,lower.to_i)
end

Given /^I have set the Interpreter's max_int to (\d+)$/ do |upper|
  @context.instance_variable_set(:@max_int,upper.to_i)
end

Given /^I have set the Interpreter's min_float to ([0-9.]+)$/ do |lower|
  @context.instance_variable_set(:@min_float,lower.to_f)
end

Given /^I have set the Interpreter's max_float to ([0-9.]+)$/ do |upper|
  @context.instance_variable_set(:@max_float,upper.to_f)
end



Given /^I have pushed an instruction called "([^"]*)" onto the :exec stack$/ do |inst|
  @context.stacks[:exec] = [DoPoint.new(inst)]
end


When /^I take one execution step$/ do
  @context.step
end


When /^I run the interpreter$/ do
  @context.run
end


When /^I parse that blueprint$/ do
  @feature_tree = NudgePoint.from(@feature_blueprint)
end


Then /^the result should be a NilPoint$/ do
  @feature_tree.should be_a_kind_of(NilPoint)
end

Then /^the interpreter's ([^"]*) should be ([-0-9.]+)$/ do |variable_name, value|
  @context.instance_variable_get(variable_name.intern).to_s.should == value
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

Then /^stack :([^"]*) should have pushed (\d+) items$/ do |stackname, count|
  @context.stacks[stackname.intern].items_pushed.should == count.to_i
end

Then /^stack :float should not contain a value less than ([0-9.]+)$/ do |lower_limit|
  @context.stacks[:float].count {|result| result.to_f < lower_limit.to_f}.should == 0
end

Then /^stack :float should not contain a value greater than ([0-9.]+)$/ do |upper_limit|
  @context.stacks[:float].count {|result| result.to_f < upper_limit.to_f}.should == 0
end
