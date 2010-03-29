require 'active_support'

class Extend_Nudge < Thor::Group
  include Thor::Actions
  
  # Define arguments and options
  argument :project_name
  class_option :test_framework, :default => :rspec

  def self.source_root
    File.dirname(__FILE__)
  end
end


class New_Nudge_Type < Thor::Group
  include Thor::Actions
  
  # Define arguments and options
  argument :type_root
  class_option :test_framework, :default => :rspec
  desc "Creates a new NudgeType class definition file, typical instructions, and rspec files"
  

  def self.source_root
    File.dirname(__FILE__)
  end
  
  def self.type_name(string)
    string.camelize + "Type"
  end
  
  def create_lib_file
    @camelcased_type_name = New_Nudge_Type.type_name(type_root)
    filename = "#{@camelcased_type_name}.rb"
    template('templates/nudge_type_class.erb', "#{type_root}/lib/#{@camelcased_type_name}.rb")
  end
  
  def create_lib_spec
    @camelcased_type_name = New_Nudge_Type.type_name(type_root)
    filename = "#{@camelcased_type_name}.rb"
    template('templates/nudge_type_class.erb', "#{type_root}/lib/#{@camelcased_type_name}.rb")
  end
end