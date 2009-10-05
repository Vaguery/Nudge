module Helpers
  def dominated_by?(other)
    noWorse = true
    somewhatBetter = false
    self.each_index do |i|
      noWorse &&= (self[i]>=other[i])
      somewhatBetter ||= (self[i]>other[i])
    end
    return noWorse && somewhatBetter
  end

  def domination_classes
    result = Hash.new()
    self.each_index do |i|
      dominatedBy = 0
      self.each_index do |j|
        dominatedBy += 1 if self[i].dominated_by?(self[j])
      end
      result[dominatedBy] ||= []
      result[dominatedBy] << self[i]
    end
    return result
  end
end