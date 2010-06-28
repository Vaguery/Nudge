class ExecEqualQ < NudgeInstruction
  get 2, :exec
  
  def process
    put :bool, exec(0).to_script == exec(1).to_script
  end
end
