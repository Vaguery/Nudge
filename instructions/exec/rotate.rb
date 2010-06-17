class Instruction::ExecRotate < Instruction
  get 3, :exec
  
  def process
    put :exec, exec(1)
    put :exec, exec(0)
    put :exec, exec(2)
  end
end
