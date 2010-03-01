#encoding: utf-8
require 'treetop'
Treetop.load(File.join(File.dirname(__FILE__),'grammars', "nudge_codeblock.treetop"))


module Nudge
  class NudgeProgram
    
    attr_accessor :code_section, :footnote_section
    attr_accessor :linked_code,:footnotes
    attr_reader :raw_code
    attr_reader :parser
    attr_reader :points
    
    
    def initialize(sourcecode)
      raise(ArgumentError, "NudgeProgram.new should be passed a string") unless sourcecode.kind_of?(String)
      @raw_code = sourcecode
      program_split!
      @parser = NudgeCodeblockParser.new
      relink_code!
      @points = self.points
    end
    
    
    def program_split!
      split_at_first_guillemet=@raw_code.partition( /^(?=«)/ )
      @code_section = split_at_first_guillemet[0].strip
      @footnote_section = split_at_first_guillemet[2].strip
      @footnotes = parsed_footnotes
    end
    
    
    def parsed_footnotes
      shattered = @footnote_section.split( /^(?=«)/ )
      breaker = /^«([a-zA-Z][a-zA-Z0-9_]*)»\s*(.*)\s*/m
      pairs = shattered.collect {|fn| fn.match(breaker)[1..2]}
      fn = Hash.new {|hash, key| hash[key] = [] }
      @footnote_order = []
      pairs.each do |key,value|
        fn[key.to_sym] << value.strip
      end
      return fn
    end
    
    
    def relink_code!
      if parses?
        @linked_code = @parser.parse(@code_section).to_point
        depth_first_association!
      else
        @linked_code = nil
      end
    end
    
    
    def depth_first_association!(program_point=@linked_code)
      if program_point.kind_of?(ValuePoint)
        program_point.raw = @footnotes[program_point.type].shift
        if program_point.raw != nil
          if program_point.type == :code
            program_point.raw << pursue_more_footnotes(program_point.raw)
          end
        end
      elsif program_point.kind_of?(CodeblockPoint)
        program_point.contents.each {|branch| depth_first_association!(branch)}
      end
    end
    
    
    def pursue_more_footnotes(codepoint_as_string, collected_footnotes = "")
      local_footnotes = ""
      if self.contains_valuepoints?(codepoint_as_string)
        local_parsetree = @parser.parse(codepoint_as_string)
        if local_parsetree != nil
          local_subtree = local_parsetree.to_point
          if local_subtree.kind_of?(CodeblockPoint)
            local_subtree.contents.each do |branch|
              local_footnotes << pursue_more_footnotes(branch.tidy)
            end
          elsif local_subtree.kind_of?(ValuePoint)
            local_subtree.raw = @footnotes[local_subtree.type].shift
            if local_subtree.raw != nil
              local_footnotes = "\n«#{local_subtree.type}» #{local_subtree.raw}"
              if local_subtree.type == :code
                local_footnotes << pursue_more_footnotes(local_subtree.raw,collected_footnotes)
              end
            end
          end
        end
      end
      return collected_footnotes + local_footnotes
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
      NudgeProgram.new(self.listing)
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
        parent = result.linked_code.detect {|wrapper| wrapper.contents.include?(to_replace)}
        parent_index = parent.contents.find_index(to_replace)
        parent.contents[parent_index] = new_junk
      end
      
      return result
    end
    
    
    def parses?(program_listing = @code_section)
      (@parser.parse(program_listing) != nil)
    end
    
    
    def tidy
      framework = NudgeCodeblockParser.new.parse(@code_section)
      framework ? framework.tidy : ""
    end
    
    
    def listing
      code_section, footnote_section = @linked_code.listing_parts
      unused_footnotes.each {|fn| footnote_section += "\n#{fn}"}
      return (code_section.strip + " \n" + footnote_section.strip).strip
    end
    
    
    def contains_codevalues?(program_listing = @raw_code)
      (program_listing =~ /value\s*«code»/) != nil
    end
    
    def contains_valuepoints?(program_listing = @raw_code)
      (program_listing =~ /value\s*«[\p{Alpha}][_\p{Alnum}]*»/) != nil
    end
    
    
    def points
      return @linked_code ? @linked_code.points : 0
    end
  end
end