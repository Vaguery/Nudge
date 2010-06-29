class ExecS < NudgeInstruction
  get 1, :exec
  
  def process
    a = exec(0)
    b = exec(1)
    c = exec(2)
    
    block = BlockPoint.new(b, c)
    
    put :exec, block
    put :exec, c
    put :exec, a
  end
end
