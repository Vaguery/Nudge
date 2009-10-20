require 'rubygems'
require 'couchrest'

# db = CouchRest.database!("http://127.0.0.1:5984/nudge_spike1")

class Guy < CouchRest::ExtendedDocument
  use_database CouchRest.database!("http://127.0.0.1:5984/nudge_spike1")
  # persists :name, :age, :scores
end

def name
  self[:name]
end

def name=(name)
  self[:name] = name
end

g = Guy.new
g[:name] = 'hi'
g[:thing2] = "also"
g.save
