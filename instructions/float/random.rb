# encoding: UTF-8
class FloatRandom < NudgeInstruction
  def process
    min = @executable.instance_variable_get(:@min_float)
    max = @executable.instance_variable_get(:@max_float)
    
    put :float, (rand(max - min) + min).to_f
  end
end
