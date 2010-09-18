require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format progress -r features/steps -r nudge.rb"
end


Cucumber::Rake::Task.new(:instructions) do |t|
  t.cucumber_opts = "features/instructions --format progress -r features/steps -r nudge.rb"
end


Cucumber::Rake::Task.new(:name) do |t|
  t.cucumber_opts = "features/instructions/name --format progress -r features/steps -r nudge.rb"
end
