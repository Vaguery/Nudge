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
    
    gemspec.add_dependency('couchrest')
    gemspec.add_dependency('sinatra')
    gemspec.add_dependency('treetop')
    gemspec.add_dependency('polyglot')
    gemspec.add_dependency('active_support')
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end