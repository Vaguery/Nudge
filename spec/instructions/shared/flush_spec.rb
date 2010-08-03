# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))

%w(Bool Code Float Int Name Proportion).each do |name|
  exe = NudgeExecutable.new("block {}").step
  exe.stacks[:bool] << true
  exe.stacks[:code] << "block {}"
  exe.stacks[:float] << 1.0
  exe.stacks[:int] << 1
  exe.stacks[:name] << :x
  exe.stacks[:proportion] << 0.0909090909
  
  describe "#{name}Flush" do
    describe "#process" do
      it "empties the :#{name.downcase} stack" do
        NudgeInstruction.execute(:"#{name.downcase}_flush", exe)
        exe.stacks[name.downcase.intern].should == []
      end
    end
  end
end
