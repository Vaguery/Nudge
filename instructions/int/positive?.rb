# encoding: UTF-8
class IntPositiveQ < NudgeInstruction
  get 1, :int
  
  def process
    put :bool, int(0) > 0
  end
end
