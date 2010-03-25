require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "nudge"
    gemspec.summary = "Nudge Language interpreter"
    gemspec.description = "Provides a Nudge Language interpreter, including the full set of instructions found in Push3, and an extensible means of adding domain-specific instructions. Can be used within Ruby projects to build and run Nudge programs, or via a command line interface. It depends on Ruby 1.9+ and a number of other gems."
    gemspec.email = "bill@vagueinnovation.com"
    gemspec.homepage = "http://github.com/Vaguery/Nudge"
    gemspec.authors = ["Bill Tozier", "Trek Glowacki", "Jesse Sielaff"]
    
    gemspec.required_ruby_version = '>= 1.9.1'
    
    gemspec.add_dependency('treetop', '>= 1.4.3')
    gemspec.add_dependency('polyglot', '>= 0.2.9')
    gemspec.add_dependency('activesupport', '>= 2.3.5')
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end