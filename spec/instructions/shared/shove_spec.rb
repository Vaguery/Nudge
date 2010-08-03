# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))

%w(Bool Code Float Int Name Proportion).each do |name|
  exe = NudgeExecutable.new("block {}").step
  exe.stacks[:bool] << true
  exe.stacks[:bool] << true
  exe.stacks[:bool] << true
  exe.stacks[:bool] << false
  exe.stacks[:code] << "block {}"
  exe.stacks[:code] << "block { block {} }"
  exe.stacks[:code] << "block { block { block {} } }"
  exe.stacks[:code] << "block { block { block { block {} } } }"
  exe.stacks[:float] << 1.0
  exe.stacks[:float] << 2.0
  exe.stacks[:float] << 3.0
  exe.stacks[:float] << 4.0
  exe.stacks[:int] << 1
  exe.stacks[:int] << 2
  exe.stacks[:int] << 3
  exe.stacks[:int] << 4
  exe.stacks[:name] << :w
  exe.stacks[:name] << :x
  exe.stacks[:name] << :y
  exe.stacks[:name] << :z
  exe.stacks[:proportion] << 0.0009000900
  exe.stacks[:proportion] << 0.0090090090
  exe.stacks[:proportion] << 0.0900900900
  exe.stacks[:proportion] << 0.9009009009
  
  exe.stacks[:int] << 2
  
  describe "#{name}Shove" do
    describe "#process" do
      it "pops the top item off of the :int stack and pushes the top item in the :#{name.downcase} stack down by that many positions" do
        old_top_value = exe.stacks[name.downcase.intern][name == "Int" ? -2 : -1]
        expected_new_top_value = exe.stacks[name.downcase.intern][name == "Int" ? -3 : -2]
        NudgeInstruction.execute(:"#{name.downcase}_shove", exe)
        exe.stacks[name.downcase.intern][-3].should == old_top_value
        exe.stacks[name.downcase.intern][-1].should == expected_new_top_value
      end
    end
  end
end
