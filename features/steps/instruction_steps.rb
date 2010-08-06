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


Given /^I have stubbed the random value method so it produces an* :([a-z\d_]+) with value "([^"]*)"$/ do |type, result|
  pending # express the regexp above with the code you wish you had
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

Then /^the result should be a random :([a-z\d_]+) value$/ do |type|
  pending
end


Then /^name "([^"]*)" should be bound to "([^"]*)"$/ do |name, value|
  bound_value = @context.variable_bindings[name.intern]

  unless bound_value.class == Value
    bound_value.script_and_values.should == NudgePoint.from(value).script_and_values
  else
    bound_value.instance_variable_get(:@string).should == value
  end
      
end