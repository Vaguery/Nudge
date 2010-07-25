# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))

%w(Bool Code Exec Float Int Name Proportion).each do |name|
  outcome_data = Outcome.new({})
  outcome_data.stacks[:bool].push "true"
  outcome_data.stacks[:bool].push "false"
  outcome_data.stacks[:code].push "block {}"
  outcome_data.stacks[:code].push "block {}"
  outcome_data.stacks[:exec].push NudgePoint.from("block {}")
  outcome_data.stacks[:exec].push NudgePoint.from("block {}")
  outcome_data.stacks[:float].push "1.0"
  outcome_data.stacks[:float].push "2.0"
  outcome_data.stacks[:int].push "1"
  outcome_data.stacks[:int].push "2"
  outcome_data.stacks[:name].push "x"
  outcome_data.stacks[:name].push "y"
  outcome_data.stacks[:proportion].push "0.0909090909"
  outcome_data.stacks[:proportion].push "0.9090909091"
  
  describe "#{name}Depth" do
    describe "#process()" do
      it "pushes the length of the :#{name.downcase} stack to the :int stack" do
        NudgeInstruction.execute(:"#{name.downcase}_depth", outcome_data)
        outcome_data.stacks[:int].pop.should == "2"
      end
    end
  end
end
