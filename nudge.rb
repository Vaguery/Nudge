# encoding: UTF-8
Dir.glob(File.expand_path("nudge_*.rb", File.dirname(__FILE__))) {|file| require file }
Dir.glob(File.expand_path("points/*.rb", File.dirname(__FILE__))) {|file| require file }
Dir.glob(File.expand_path("instructions/*/*.rb", File.dirname(__FILE__))) {|file| require file }
