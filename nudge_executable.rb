# encoding: UTF-8
class NudgeExecutable
  def initialize (script)
    @tree = NudgePoint.from script
    set_options({})
    bind({})
  end
  
  def set_options (options)
    @point_limit = options[:point_limit] || 3000
    @time_limit = options[:time_limit] || 1
    
    float_range = options[:float_range] || (-100..100)
    int_range = options[:int_range] || (-100..100)
    
    @min_float, @max_float = [float_range.begin, float_range.end].sort
    @min_int, @max_int = [int_range.begin, int_range.end].sort
  end
  
  def bind (variable_bindings)
    @variable_bindings = variable_bindings
    reset
  end
  
  def reset
    @points_evaluated = 0
    @time_elapsed = 0
    @allow_lookup = true
    
    @stacks = Hash.new {|hash, key| hash[key] = NudgeStack.new(key) }
    @stacks[:exec] = ExecStack.new(:exec) << @tree
    @stacks[:error] = ErrorStack.new(:error)
    
    self
  end
  
  def step (n = 1)
    n.times do
      break unless point = @stacks[:exec].pop_value
      
      t = Time.now.to_f
      
      begin
        point.evaluate(self)
      rescue NudgeError => error
        @stacks[:error] << error
      end
      
      @time_elapsed += Time.now.to_f - t
      @points_evaluated += 1
    end
    
    self
  end
  
  def run
    exec_stack = @stacks[:exec]
    error_stack = @stacks[:error]
    
    begin
      while point = exec_stack.pop_value
        t = Time.now.to_f
        
        begin
          point.evaluate(self)
        rescue NudgeError => error
          error_stack << error
        end
        
        if (@time_elapsed += Time.now.to_f - t) > @time_limit
          raise NudgeError::TimeLimitExceeded, "the time limit was exceeded after evaluating #{@points_evaluated += 1} points"
        elsif (@points_evaluated += 1) >= @point_limit
          raise NudgeError::TooManyPointsEvaluated, "the point evaluation limit was exceeded after #{@time_elapsed} seconds"
        end
      end
      
    rescue NudgeError => error
      error_stack << error
    end
    
    self
  end
  
  def lookup_allowed?
    result = @allow_lookup
    @allow_lookup = true
    result
  end
  
  def points_evaluated
    @points_evaluated
  end
  
  def stacks
    @stacks
  end
  
  def time_elapsed
    @time_elapsed
  end
  
  def variable_bindings
    @variable_bindings
  end
end
