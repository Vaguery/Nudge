#encoding: utf-8

module Nudge
  class NudgeProgram
    
    def self.random(options = {})
      sourcecode = CodeType.any_value(options)
      NudgeProgram.new(sourcecode)
    end
    

    attr_accessor :linked_code,:footnotes
    attr_accessor :raw_code
    attr_accessor :code_section, :footnote_section
    attr_reader :points
    
    
    def initialize(sourcecode)
      raise(ArgumentError, "NudgeProgram.new should be passed a string") unless sourcecode.kind_of?(String)
      @raw_code = sourcecode
      
      split_at_first_guillemet=@raw_code.partition( /^(?=«)/ )
      @code_section = split_at_first_guillemet[0].strip
      @footnote_section = split_at_first_guillemet[2].strip
      
      parsed_code = NudgeTree.from(@raw_code)
      @linked_code = parsed_code[:tree] 
      @footnotes = parsed_code[:unused]
      @points = self.points
    end
    
    
    
    def unused_footnotes
      leftovers = []
      @footnotes.each do |key,val|
        val.each {|fn| leftovers << "«#{key.to_s}» #{fn.strip}"}
      end
      return leftovers
    end
    
    
    
    def [](which)
      raise ArgumentError,"Cannot retrieve #{which}th program point" if which < 1
      raise ArgumentError,"Cannot retrieve #{which}th program point" if which > self.points
      if which == 1
        result = @linked_code
      else
        result = @linked_code.each_with_index do |node,index|
          break(node) if index == which-1
        end
      end
      return result
    end
    
    
    
    def deep_copy
      NudgeProgram.new(self.blueprint)
    end
    
    
    
    def replace_point(which,new_junk)
      raise ArgumentError,"Cannot replace #{which}th program point" if which < 1
      raise ArgumentError,"Cannot replace #{which}th program point" if which > self.points
      raise ArgumentError,"Cannot insert #{new_junk.class}" unless new_junk.kind_of?(ProgramPoint)
      
      result = self.deep_copy
      
      if which == 1
        result.linked_code = new_junk
      else
        to_replace = result[which]
        parent = result.linked_code.detect do |wrapper|
          wrapper.contents.include?(to_replace) if wrapper.respond_to?(:contents)
        end
        parent_index = parent.contents.find_index(to_replace)
        parent.contents[parent_index] = new_junk
      end
      
      result.cleanup_strings_from_linked_code!
      return result
    end
    
    
    
    def insert_point_before(which, new_junk)
      raise ArgumentError,"Cannot insert at #{which}th position" if which < 1
      raise ArgumentError,"Cannot insert before #{which}th program point" if which > (self.points+1)
      raise ArgumentError,"Cannot insert #{new_junk.class}" unless new_junk.kind_of?(ProgramPoint)
      
      copy = self.deep_copy
      
      case which
      when 1
        copy.linked_code = CodeblockPoint.new([new_junk, copy.linked_code])
      when copy.points+1
        copy.linked_code = CodeblockPoint.new([copy.linked_code, new_junk])
      else
        stick_before_this = copy[which]
        parent_node = copy.linked_code.detect do |wrapper|
          wrapper.contents.include?(stick_before_this) if wrapper.respond_to?(:contents)
        end
        parent_index = parent_node.contents.find_index(stick_before_this)
        parent_node.contents.insert(parent_index, new_junk)
      end
      copy.cleanup_strings_from_linked_code!
      return copy
    end
    
    
    
    def delete_point(which)
      raise ArgumentError,"Cannot delete #{which}th program point" if which < 1
      raise ArgumentError,"Cannot delete #{which}th program point" if which > self.points
      
      if which == 1
        result = NudgeProgram.new("block {}")
        result.footnotes = self.footnotes
      else
        result = self.deep_copy
        to_delete = result[which]
        parent = result.linked_code.detect do |wrapper|
          wrapper.contents.include?(to_delete) if wrapper.respond_to?(:contents)
        end
        parent_index = parent.contents.find_index(to_delete)
        parent.contents.delete_at(parent_index)
      end
      
      result.cleanup_strings_from_linked_code!
      return result
    end
    
    
    
    def cleanup_strings_from_linked_code!
      @raw_code = self.blueprint
      split_at_first_guillemet=@raw_code.partition( /^(?=«)/ )
      @code_section = split_at_first_guillemet[0].strip
      @footnote_section = split_at_first_guillemet[2].strip
    end
    
    
    
    def parses?(program_blueprint = @code_section)
      !NudgeTree.from(program_blueprint)[:tree].kind_of?(NilPoint)
    end
    
    
    
    def tidy
      NudgeTree.from(@raw_code)[:tree].tidy
    end
    
    
    
    def blueprint
      if @linked_code.kind_of? NilPoint
        return ""
      else
        code_section, footnote_section = @linked_code.blueprint_parts
        unused_footnotes.each {|fn| footnote_section += "\n#{fn}"}
        return (code_section.strip + " \n" + footnote_section.strip).strip
      end
    end
    
    
    def contains_codevalues?(program_blueprint = @raw_code)
      (program_blueprint =~ /value\s*«code»/) != nil
    end
    
    def contains_valuepoints?(program_blueprint = @raw_code)
      (program_blueprint =~ /value\s*«[\p{Alpha}][_\p{Alnum}]*»/) != nil
    end
    
    
    
    def points
      return @linked_code ? @linked_code.points : 0
    end
  end
end