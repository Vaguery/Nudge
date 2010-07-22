# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))

%w(Bool Code Exec Float Int Name Proportion).each do |name|
  outcome_data = Outcome.new({})
  outcome_data.stacks[:bool].push "true"
  outcome_data.stacks[:bool].push "true"
  outcome_data.stacks[:bool].push "true"
  outcome_data.stacks[:bool].push "false"
  outcome_data.stacks[:code].push "block {}"
  outcome_data.stacks[:code].push "block { block {} }"
  outcome_data.stacks[:code].push "block { block { block {} } }"
  outcome_data.stacks[:code].push "block { block { block { block {} } } }"
  outcome_data.stacks[:exec].push NudgePoint.from("block {}")
  outcome_data.stacks[:exec].push NudgePoint.from("block { block {} }")
  outcome_data.stacks[:exec].push NudgePoint.from("block { block { block {} } }")
  outcome_data.stacks[:exec].push NudgePoint.from("block { block { block { block {} } } }")
  outcome_data.stacks[:float].push "1.0"
  outcome_data.stacks[:float].push "2.0"
  outcome_data.stacks[:float].push "3.0"
  outcome_data.stacks[:float].push "4.0"
  outcome_data.stacks[:int].push "1"
  outcome_data.stacks[:int].push "2"
  outcome_data.stacks[:int].push "3"
  outcome_data.stacks[:int].push "4"
  outcome_data.stacks[:name].push "w"
  outcome_data.stacks[:name].push "x"
  outcome_data.stacks[:name].push "y"
  outcome_data.stacks[:name].push "z"
  outcome_data.stacks[:proportion].push "0.0009000900"
  outcome_data.stacks[:proportion].push "0.0090090090"
  outcome_data.stacks[:proportion].push "0.0900900900"
  outcome_data.stacks[:proportion].push "0.9009009009"
  
  outcome_data.stacks[:int].push "2"
  
  describe "#{name}Yank" do
    describe "#process()" do
      it "pops the top item off of the :int stack and pulls the item in that position on the :#{name.downcase} stack to the top" do
        old_top_value = outcome_data.stacks[name.downcase.intern][name == "Int" ? -2 : -1]
        expected_new_top_value = outcome_data.stacks[name.downcase.intern][name == "Int" ? -4 : -3]
        expected_new_third_value = outcome_data.stacks[name.downcase.intern][name == "Int" ? -3 : -2]
        NudgeInstruction.execute(:"#{name.downcase}_yank", outcome_data)
        outcome_data.stacks[name.downcase.intern][-2].should == old_top_value
        outcome_data.stacks[name.downcase.intern][-1].should == expected_new_top_value
        outcome_data.stacks[name.downcase.intern][-3].should == expected_new_third_value
      end
    end
  end
end
