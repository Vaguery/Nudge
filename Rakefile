require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "nudge"
    gemspec.summary = "Genetic Programming in the Nudge language"
    gemspec.description = "It's way complicated"
    gemspec.email = "bill@vagueinnovation.com"
    gemspec.homepage = "http://github.com/Vaguery/PragGP"
    gemspec.authors = ["Bill Tozier", "Trek Glowacki"]
    
    gemspec.add_dependency('couchrest', '>= 0.33')
    gemspec.add_dependency('sinatra', '>= 0.9.4')
    gemspec.add_dependency('treetop', '>= 1.4.3')
    gemspec.add_dependency('polyglot', '>= 0.2.9')
    gemspec.add_dependency('activesupport', '>= 2.3.5')
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end