require 'active_support'

class Extend_Nudge < Thor::Group
  include Thor::Actions
  
  # Define arguments and options
  argument :project_name
  class_option :test_framework, :default => :rspec
  desc "Creates a new project folder structure for Nudge types, instructions and specs"
  
  
  def self.source_root
    File.dirname(__FILE__)
  end
  
  def create_project_folder
    dirname = "#{Extend_Nudge.source_root}/#{project_name}"
    puts dirname
    if Dir.exist?(dirname) then
      puts "project directory 'dirname' already exists"
    else
      empty_directory(dirname)
      empty_directory("#{dirname}/lib")
      empty_directory("#{dirname}/lib/instructions")
      empty_directory("#{dirname}/lib/interpreter/types")
      empty_directory("#{dirname}/spec")
    end
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
    template('templates/nudge_type_class.erb', "#{type_root}/lib/types/#{filename}")
  end
  
  def create_lib_spec
    @camelcased_type_name = New_Nudge_Type.type_name(type_root)
    filename = "#{@camelcased_type_name}_spec.rb"
    template('templates/nudge_type_spec.erb', "#{type_root}/spec/#{filename}")
  end  
  
  def create_instructions
    suite = ["define", "equal_q", "duplicate", "flush", "pop",
      "random", "rotate", "shove", "swap", "yank", "yankdup"]
    
    suite.each do |inst|
      @core = "#{type_root}_#{inst}"
      filename = "#{@core}.rb"
      @instname = "#{@core.camelize}Instruction"
      @type = type_root
      @camelized_type = New_Nudge_Type.type_name(type_root)
      template("templates/nudge_#{inst}_instruction.erb", "#{type_root}/lib/instructions/#{filename}")
    end
  end  
  
end