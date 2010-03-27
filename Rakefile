require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "nudge"
    gemspec.summary = "Nudge Language interpreter"
    gemspec.description = "Provides a Ruby library & CLI implementing a flexible Nudge Language interpreter, plus a set of generators for adding domain-specific instructions and types."
    gemspec.email = "bill@vagueinnovation.com"
    gemspec.homepage = "http://github.com/Vaguery/Nudge"
    gemspec.authors = ["Bill Tozier", "Trek Glowacki", "Jesse Sielaff"]
    
    # Ruby
    gemspec.required_ruby_version = '>= 1.9.1'
    
    # dependencies
    gemspec.add_dependency('treetop', '>= 1.4.3')
    gemspec.add_dependency('activesupport', '>= 2.3.5')
    
    # files
    gemspec.files.exclude '_spikes/**'
    gemspec.files.exclude('exploring_nudge/**')
    
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end