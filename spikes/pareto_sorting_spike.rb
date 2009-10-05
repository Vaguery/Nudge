require 'pp'

class Array
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

(1..5).each do |dimension|
  10.times do
    a,b = [],[]
    dimension.times {a << rand(20); b << rand(20)}
    case
    when a.dominated_by?(b)
      puts "#{a.inspect} is dominated_by #{b.inspect}"
    when b.dominated_by?(a)
      puts "#{b.inspect} is dominated_by #{a.inspect}"
    else
      puts "#{a.inspect} and #{b.inspect} and both nondominated"
    end
  end
end

list = []
10.times {a = []; 3.times {a << rand(30)}; list << a}
puts "==========\nunsorted list:\n#{list.inspect}\n\nclustered by number of other points that dominate it:\n"
sorted = list.domination_classes
pp sorted
puts "\n\n#{sorted[0].length} are in the nondominated set"
puts "\n#{sorted[sorted.keys.max].length} are in the worst (most-dominated) set, dominated by #{sorted.keys.max}/#{list.length}"

puts "==========\n\nNondominated set sizes\n\n"
puts "samples\tdimension\tnon-dominated\ttime\n"

100.times do
  list = []
  count = (rand(10)+1)*100
  dim = rand(5)+1
  count.times {a = []; dim.times {a << rand(30)}; list << a}
  t1 = Time.now
  sorted = list.domination_classes
  slowness = Time.now - t1
  puts "#{list.length}\t#{dim}\t#{sorted[0].length}\t#{slowness}"
end