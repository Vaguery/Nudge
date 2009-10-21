require 'rubygems'
require 'couchrest'

module MethodAccess
  def persists(*names)
    names.each do |name|
      define_method(name) do
        self[name]
      end
      
      define_method("#{name}=") do |arg|
        self[name] = arg
      end
    end
  end
end

CouchRest::ExtendedDocument.extend(MethodAccess)
class Guy < CouchRest::ExtendedDocument
  use_database CouchRest.database!("http://127.0.0.1:5984/nudge_spike1")
  persists :name, :age
end

g = Guy.new
