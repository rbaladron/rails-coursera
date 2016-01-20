class Zip

  # convenience method for access to client in console
  def self.mongo_client
    Mongoid::Clients.Default
  end

  # convenience method for access to zips collection
  def self.collection
    self.mongo_client['zips']
  end
end

# implement a find that returns a collection of document as hashes.
# Use initializae(hash) to express individual documents as a class
# instance.
#     * prototype - quey example for value equality
#     * sort - hash expressing multi-term sort order
#     * offset - document to start results
#     * limit - number of documents to include
def self.all(prototype{}, sort={:population=>1}, offset=0, limit=100)
  # map internal :population term to :pop document term
  tmp = {} # hash needs to stay in stable order provided
  sort.each {|k,v
    k = k.to_sym==:population ? :pop : k.to_sym
    tmp[k] = v if [:city, :state, :pop].include?(k)
  }
  sort=tmp
  # convert to keys and then eliminate any properties no of interest
  prototype.each_with_object({}) {|(k,v), tmp | tmp[k.to_sym] = v; tmp}
