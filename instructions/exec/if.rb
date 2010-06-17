class Instruction::ExecIf < Instruction
  get 1, :bool
  get 2, :exec
  
  def process
    put :exec, bool(0) ? exec(0) : exec(1)
  end
end
