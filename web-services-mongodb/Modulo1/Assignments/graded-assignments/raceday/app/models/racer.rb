class Racer
  include ActiveModel::Model

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  def to_s
    "#{@id}: #{@number}, #{@first_name}, #{@last_name}, #{@gender}, #{@group}, #{@secs}"
  end

  # initialize from both a Mongo and Web hash
  def initialize(params={})
    #switch between both internal and external views of id
    @id=params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number=params[:number].to_i
    @first_name=params[:first_name]
    @last_name=params[:last_name]
    @gender=params[:gender]
    @group=params[:group]
    @secs=params[:secs].to_i
  end

  # tell Rails whether this instance is persisted
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

  # convenience method for access to racers collection
  def self.collection
   self.mongo_client['racers']
  end

  # implement a find that returns a collection of document as hashes.
  # Use initialize(hash) to express individual documents as a class
  # instance.
  #   * prototype - query example for value equality
  #   * sort - hash expressing multi-term sort order
  #   * offset - document to start results
  #   * limit - number of documents to include
  def self.all(prototype={}, sort={:num=>1}, offset=0, limit=nil)
    #map internal :population term to :pop document term
    tmp = {} #hash needs to stay in stable order provided
    sort.each {|k,v|
      k = k.to_sym==:num ? :number : k.to_sym
      tmp[k] = v  if [:number, :first_name, :last_name, :gender, :group, :secs].include?(k)
    }
    sort=tmp

    #convert to keys and then eliminate any properties not of interest
    #prototype=prototype.symbolize_keys.slice(:gender, :last_name,) if !prototype.nil?

    Rails.logger.debug {"getting all racers, prototype=#{prototype}, sort=#{sort}, offset=#{offset}, limit=#{limit}"}

    result=collection.find(prototype)
          .projection({_id:true, number:true, first_name:true, last_name:true, gender:true, group:true, secs:true })
          .sort(sort)
          .skip(offset)
    result=result.limit(limit) if !limit.nil?

    return result

  end

  # locate a specific document. Use initialize(hash) on the result to
  # get in class instance form
  def self.find id
    Rails.logger.debug {"getting racer #{id}"}

    doc=collection.find(:_id=>id)
                  .projection({id:true, number:true, first_name:true, last_name:true, gender:true, group:true, secs:true })
                  .first
    return doc.nil? ? nil : Racer.new(doc)

  end

  # create a new document using the current instance
  def save
    Rails.logger.debug {"saving #{self}"}

    self.class.collection
              .insert_one(_id:@id, number:@number, first_name:@first_name, last_name:@last_name, gender:@gender, group:@group, secs:@sec)
  end

  # update the values for this instance
  def update(updates)
    Rails.logger.debug {"updating #{self} with #{updates}"}

    #map internal :population term to :pop document term
    updates[:num]=updates[:number]  if !updates[:number].nil?
    params.slice!(:number, :first_name, :last_name, :gender, :group, :secs) if !updates.nil?

    self.class.collection
              .find(_id:@id)
              .update_one(:$set=>updates)
  end

  # remove the document associated with this instance form the DB
  def destroy
    Rails.logger.debug {"destroying #{self}"}

    self.class.collection
              .find(_id:@id)
              .delete_one
  end

end
