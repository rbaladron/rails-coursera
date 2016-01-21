class Racer
  include ActiveModel::Model

  # convenience method for access to client in console
  def self.mongo_client
   Mongoid::Clients.default
  end

  # convenience method for access to racers collection
  def self.collection
   self.mongo_client['racers']
  end
end
# implement a find that returns a collection of document as hashes.
# Use initialize(hash) to express individual documents as a class
# instance.
#   * prototype - query example for value equality
#   * sort - hash expressing multi-term sort order
#   * offset - document to start results
#   * limit - number of documents to include
def self.all(prototype={}, sort={:last_name=>1}, skip=0, limit=nil)
  #map internal :population term to :pop document term
  tmp = {} #hash needs to stay in stable order provided
  sort.each {|k,v|
    k = k.to_sym==:last_name ? :pop : k.to_sym
    tmp[k] = v  if [:number, :first_name, :last_name, :gender, :group, :secs,  :pop].include?(k)
  }
  sort=tmp

  #convert to keys and then eliminate any properties not of interest
  prototype=prototype.symbolize_keys.slice(:city, :state) if !prototype.nil?

  Rails.logger.debug {"getting all racers, prototype=#{prototype}, sort=#{sort}, skip=#{skip}, limit=#{limit}"}

  result=collection.find(prototype)
        .projection({_id:true, number:true, first_name:true, last_name:true, gender:true,group:true, secs:true})
        .sort(sort)
        .skip(offset)
  result=result.limit(limit) if !limit.nil?

  return result

end
