#encoding: utf-8

Given /^the blueprint "([^"]*)"$/ do |arg1|
  @feature_blueprint = arg1
end


When /^I parse that blueprint$/ do
  @feature_tree = NudgePoint.from(@feature_blueprint)
end