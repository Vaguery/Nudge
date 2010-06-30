require './nudge'

describe "Outcome" do
  describe ".new(variable_bindings)" do
    it "returns a new Outcome with 0 points evaluated" do
      Outcome.new({}).instance_variable_get(:@points_evaluated).should === 0
    end
    
    it "returns a new Outcome with an expiration moment stored in seconds" do
      pending
      time = Time.now
      Time.stub!(:now).and_return(time)
      puts Outcome.new({}).instance_variable_get(:@expiration_moment).inspect
      Outcome.new({}).instance_variable_get(:@expiration_moment).should === (time + Outcome::TIME_LIMIT).to_f
    end
  end
end
