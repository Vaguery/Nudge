# encoding: UTF-8
require 'spec_helper'

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
  
  describe "#{name}Yank" do
    describe "#process" do
      it "pops the top item off of the :int stack and pushes a duplicate of the item in that position on the :#{name.downcase} stack back onto the :#{name.downcase} stack" do
        old_top_value = exe.stacks[name.downcase.intern][name == "Int" ? -2 : -1]
        expected_new_top_value = exe.stacks[name.downcase.intern][name == "Int" ? -4 : -3]
        NudgeInstruction.execute(:"#{name.downcase}_yankdup", exe)
        exe.stacks[name.downcase.intern][-2].should == old_top_value
        exe.stacks[name.downcase.intern][-1].should == expected_new_top_value
        exe.stacks[name.downcase.intern][-4].should == expected_new_top_value
      end
    end
  end
end
