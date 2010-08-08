# encoding: UTF-8
require 'spec_helper'

%w(Bool Code Float Int Proportion).each do |name|
  exe = NudgeExecutable.new("block {}").step
  exe.stacks[:bool] << true
  exe.stacks[:code] << "block {}"
  exe.stacks[:float] << 1.0
  exe.stacks[:int] << 1
  exe.stacks[:proportion] << 0.0909090909
  
  exe.stacks[:name] << :x
  
  describe "#{name}Define" do
    describe "#process" do
      it "pops the top items off the :#{name.downcase} stack and the :name stack, then binds the #{name.downcase} value to a variable with that name" do
        variable_name = exe.stacks[:name][-1].intern
        expected_value = exe.stacks[name.downcase.intern][-1]
        NudgeInstruction.execute(:"#{name.downcase}_define", exe)
        exe.stacks[:name].length.should == 0
        exe.stacks[name.downcase.intern].length.should == 0
        exe.variable_bindings[variable_name].instance_variable_get(:@value).should == expected_value
      end
    end
  end
end
