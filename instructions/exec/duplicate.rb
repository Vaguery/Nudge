class Instruction::ExecDuplicate < Instruction
  get 1, :exec
  
  def process
    put :exec, exec(0)
    put :exec, exec(0)
  end
end
