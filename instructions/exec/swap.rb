class Instruction::ExecSwap < Instruction
  get 2, :exec
  
  def process
    put :exec, exec(0)
    put :exec, exec(1)
  end
end
