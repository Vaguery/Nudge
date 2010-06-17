class Executable
  def initialize (script)
    @point = NudgePoint.from(script)
    @variable_bindings = {}
  end
  
  def bind (variable_bindings)
    @variable_bindings = variable_bindings
    self
  end
  
  def run
    outcome_data = Outcome.new(@variable_bindings)
    exec_stack = outcome_data.stacks[:exec]
    exec_stack.push(@point)
    
    while point = exec_stack.pop
      point.evaluate(outcome_data)
    end
    
    return outcome_data
  end
end

exe = Executable.new("block {}")

exe.bind({:x => Value.new(:int, 100)})

exe.run

exe.bind()
exe.run

