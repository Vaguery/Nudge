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
      pairs.each { |key,value| fn[key.to_sym] << value.chomp}
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
        program_point.value = @footnotes[program_point.type].shift
        if program_point.value != nil
          if program_point.type == :code
            program_point.value << pursue_more_footnotes(program_point.value)
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
            local_subtree.value = @footnotes[local_subtree.type].shift
            if local_subtree.value != nil
              local_footnotes = "\n«#{local_subtree.type}» #{local_subtree.value}"
              if local_subtree.type == :code
                local_footnotes << pursue_more_footnotes(local_subtree.value,collected_footnotes)
              end
            end
          end
        end
      end
      return collected_footnotes + local_footnotes
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
      return (code_section.strip + " \n" + footnote_section.strip).strip
    end
    
    
    def contains_codevalues?(program_listing = @raw_code)
      (program_listing =~ /value\s*«code»/) != nil
    end
    
    def contains_valuepoints?(program_listing = @raw_code)
      (program_listing =~ /value\s*«[\p{Alpha}][_\p{Alnum}]*»/) != nil
    end
    
    
    def points
      @points ||= (@linked_code ? @linked_code.points : 0)
    end
  end
end