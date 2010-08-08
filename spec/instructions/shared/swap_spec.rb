# encoding: UTF-8
require 'spec_helper'

%w(Bool Code Float Int Name Proportion).each do |name|
  exe = NudgeExecutable.new("block {}").step
  exe.stacks[:bool] << false
  exe.stacks[:bool] << false
  exe.stacks[:bool] << true
  exe.stacks[:code] << "block {}"
  exe.stacks[:code] << "block { do int_add }"
  exe.stacks[:code] << "block { do int_add do int_add }"
  exe.stacks[:float] << 1.0
  exe.stacks[:float] << 2.0
  exe.stacks[:float] << 3.0
  exe.stacks[:int] << 1
  exe.stacks[:int] << 2
  exe.stacks[:int] << 3
  exe.stacks[:name] << :x
  exe.stacks[:name] << :y
  exe.stacks[:name] << :z
  exe.stacks[:proportion] << 0.1
  exe.stacks[:proportion] << 0.2
  exe.stacks[:proportion] << 0.3
  
  describe "#{name}Swap" do
    describe "#process" do
      it "swaps the positions of the top two items in the :#{name.downcase} stack" do
        expected_new_top_value = exe.stacks[name.downcase.intern][-2]
        expected_new_second_value = exe.stacks[name.downcase.intern][-1]
        expected_new_third_value = exe.stacks[name.downcase.intern][-3]
        NudgeInstruction.execute(:"#{name.downcase}_swap", exe)
        
        exe.stacks[name.downcase.intern][-1].should == expected_new_top_value
        exe.stacks[name.downcase.intern][-2].should == expected_new_second_value
        exe.stacks[name.downcase.intern][-3].should == expected_new_third_value
      end
    end
  end
end
