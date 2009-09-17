orig = "block {\nblock{\n}}"
clean = "block {\n  block {}}"

def orig.tidy
  n = self
  n = n.gsub(/\n/,'')
  n = n.gsub(/\{/,'{\n  ')
  n = n.gsub(/\n/,'\n  ')
  return n
end

puts orig.tidy + "\n" + (orig.tidy == clean).inspect


