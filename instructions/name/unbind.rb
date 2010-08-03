# encoding: UTF-8
class NameUnbind < NudgeInstruction
  get 1, :name
  
  def process
    @executable.variable_bindings.delete(name(0))
  end
end
