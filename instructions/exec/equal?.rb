# encoding: UTF-8
class ExecEqualQ < NudgeInstruction
  get 2, :exec
  
  def process
    # exec(x) can somehow be nil
    
    put :bool, exec(0).to_script == exec(1).to_script
  rescue NoMethodError
  end
end
