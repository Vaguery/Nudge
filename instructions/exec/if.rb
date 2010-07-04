class ExecIf < NudgeInstruction
  get 1, :bool
  get 2, :exec
  
  def process
    put :exec, bool(0) ? exec(1) : exec(0)
  end
end
