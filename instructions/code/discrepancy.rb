# encoding: UTF-8
class CodeDiscrepancy < NudgeInstruction
  get 2, :code
  
  def process
    arg1 = NudgePoint.from(code(1))
    arg2 = NudgePoint.from(code(0))
    
    if arg1.is_a?(NilPoint) || arg2.is_a?(NilPoint)
      raise NudgeError::InvalidScript,"code_discrepancy can't parse an argument"
    end
    
    pts_1 = point_hash(arg1)
    pts_2 = point_hash(arg2)
    
    all_pts = pts_1.keys | pts_2.keys
    discrepancy = all_pts.collect {|pt| (pts_1[pt] - pts_2[pt]).abs}
    
    put :int, discrepancy.inject(:+)
  end
  
  
  def point_hash(tree)
    hash = Hash.new(0)
    (0...tree.points).each do |i|
      hash[tree.get_point_at(i).to_script] += 1
    end
    hash
  end
end
