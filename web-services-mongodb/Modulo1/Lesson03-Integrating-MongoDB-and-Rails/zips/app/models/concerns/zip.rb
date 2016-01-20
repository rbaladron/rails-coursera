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

  # locate  a specific document. Use initialize(hash) on the result to
  # get in class instance form
  def self.find id
    Rails.logger.debug{"getting zip #{id}"}

    doc=collection.find(:_id=>id)
                  .projection({_id:true, citi:true, state:true, pop:true})
                  .first
    return doc.nil? ? nil : Zip.new(doc)
  end

  # Create a new document using the current instance
  def save
    Rails.logger.debug {"saving #{self}"}

    self.class.collection
              .insert_one(_id:@id, city:@city, state:@state, pop:@population)
  end

  # udate the values for this instance
  def update(updates)
    Rails.logger.debug {"updating #{self} with #{updates}"}

    # map internal :population term to :pop document term
    updates[:pop]=updates[:population] if !updates[:population].nil?
    updates.slice!(:city, :state, :pop) if !updates.nil?

    self.class.collection
              .find(_:id:@id)
              .update_one(updates)
  end
