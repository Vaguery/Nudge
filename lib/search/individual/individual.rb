require 'couchrest'

module Nudge
  class Individual    
    def self.get(db_url, individual_id)
      # connect
      db = CouchRest.database!(db_url)
      
      # search
      couchDoc = db.get(individual_id.to_s)
      
      # create new guy
      newDude = self.new(couchDoc["genome"])
      newDude.instance_variable_set('@id',couchDoc["_id"])
      newDude.timestamp = couchDoc["creation_time"]
      newDude.scores = couchDoc["scores"]
      
      return newDude
    end
    
    
    attr_accessor :scores, :progress, :ancestors, :station_name, :program, :timestamp
    attr_reader :id
    
    
    def initialize(code="block {}")
      if code.kind_of?(String)
        @program = NudgeProgram.new(code)
      elsif code.kind_of?(NudgeProgram)
        @program = code
      else
        raise(ArgumentError, "Individuals cannot be made from #{code.class} objects")
      end
        
      @scores = Hash.new
      @timestamp = Time.now
      @progress = 0
      @ancestors = []
      @station_name = ""
    end
    
    
    def genome
      self.program.listing
    end
    
    
    def parses?
      self.program.parses?
    end
    
    
    def known_scores
      return self.scores.keys.sort
    end
    
    
    
    def points
      return self.program.points
    end
    
    
    def score_vector(template = self.known_scores)
      vector = []
      template.each {|obj| vector << self.scores[obj]}
      return vector
    end
    
    
    def dominated_by?(other, template = self.known_scores)
      noWorse = true
      somewhatBetter = false
      template.each do |score|
        if self.scores[score] && other.scores[score]
          noWorse &&= (self.scores[score] >= other.scores[score])
          somewhatBetter ||= (self.scores[score] > other.scores[score])
        else
          return false
        end
      end
      return noWorse && somewhatBetter
    end
    
    
    def delete_point(which)
      return self.program.listing if (which < 1 || which > self.program.points)
      return "block {}" if which == 1
      chunks = isolate_point(which)
      variant = chunks[:left] + chunks[:right]
      return variant
    end
    
    
    def replace_point_or_clone(which, object)
      if object.kind_of?(String)
        prog = NudgeProgram.new(object)
        if !prog.parses?
          raise(ArgumentError, "Replacement point cannot be parsed")
        else
          new_point = prog.linked_code
        end
      elsif object.kind_of?(ProgramPoint)
        new_point = object
      else
        raise(ArgumentError, "Program points cannot be replaced by #{object.class} objects")
      end
      
      if (which < 1 || which > self.points)
        result = self.program.deep_copy
      else
        result = self.program.replace_point(which,new_point)
      end
      
      return result
    end
    
    
    def write
      where = CouchRest.database!(@station.database)
      response = where.save_doc({
        "genome" => @genome,
        "scores" => @scores,
        "creation_time" => @timestamp})
      @id = response["id"]
    end
  end
end