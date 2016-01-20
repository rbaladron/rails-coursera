class Zip
  include ActiveModel::Model

  def persisted?
    !@id.nil?
  end
  def created_at
    nil
  end
  def updated_at
    nil
  end

  # convenience method for access to client in console
  def self.mongo_client
    Mongoid::Clients.default
  end

  # convenience method for access to zips collection
  def self.collection
    self.mongo_client['zips']
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
  sort.each {|k,v|
    k = k.to_sym==:population ? :pop : k.to_sym
    tmp[k] = v if [:city, :state, :pop].include?(k)
  }
  sort=tmp
  # convert to keys and then eliminate any properties no of interest
  prototype=prototype.symboliz_keys.slice(:cit, :state) if !prototype.nil?


  Rails.logger.debug{"getting all zips, prototype=#{prototype}, sort=#{sort}, offset=#{offset}, limit=#{limit}"}

  result = collection.find(prototype)
                      .projection({_id:true, city:true, state:true, pop:true})
                      .sort(sort)
                      .skip(offset)
  result=result.limit(limit) if !limit.nil?

  return result
end

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

  # remove the document associated with this instance from the DB
  def destroy
    Rails.logger.debug{"destroying #{self}"}

    self.class.collection
              .find(_id:@id)
              .delete_one
  end

  def self.paginate(params)
    Rails.logger.debug("paginate(#{params})")
    page=(params[:page] ||=1).to_i
    limit=(params[:per_page] ||= 30).to_i
    offset=(page-1)*limit

    # get the associated page of Zips -- eagerly conver doc to Zip
    zips=[]
    all({}, {}, offset, limit).each do |doc|
      zips << Zip.new(doc)
    end

    # get a count of all documents in the collection
    total = all({}, {}, 0, 1).count

    WillPaginate::Collection.create(page, limit, total) do |pager|
      pager.replace(zips)
    end
  end
end
