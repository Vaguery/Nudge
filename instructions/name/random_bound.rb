# encoding: UTF-8
class NameRandomBound < NudgeInstruction
  def process
    return unless random_bound = @executable.variable_bindings.keys.shuffle.first
    
    put :name, random_bound
  end
end
