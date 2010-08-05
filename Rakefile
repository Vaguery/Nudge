require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:instructions) do |t|
  t.cucumber_opts = "features/instructions --format progress -r features/steps -r nudge.rb"
end

Cucumber::Rake::Task.new(:bool) do |t|
  t.cucumber_opts = "features/instructions/bool --format progress -r features/steps -r nudge.rb"
end

Cucumber::Rake::Task.new(:int) do |t|
  t.cucumber_opts = "features/instructions/int --format progress -r features/steps -r nudge.rb"
end

Cucumber::Rake::Task.new(:float) do |t|
  t.cucumber_opts = "features/instructions/float --format progress -r features/steps -r nudge.rb"
end

Cucumber::Rake::Task.new(:proportion) do |t|
  t.cucumber_opts = "features/instructions/proportion --format progress -r features/steps -r nudge.rb"
end

Cucumber::Rake::Task.new(:code) do |t|
  t.cucumber_opts = "features/instructions/code --format progress -r features/steps -r nudge.rb"
end

Cucumber::Rake::Task.new(:exec) do |t|
  t.cucumber_opts = "features/instructions/exec --format progress -r features/steps -r nudge.rb"
end

Cucumber::Rake::Task.new(:shared) do |t|
  t.cucumber_opts = "features/instructions/shared --format progress -r features/steps -r nudge.rb"
end
