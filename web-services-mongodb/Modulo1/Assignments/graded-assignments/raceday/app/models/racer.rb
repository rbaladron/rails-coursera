class Racer
  include ActiveModel::Model

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  def to_s
    "#{@id}: num=#{@number}, first_name=#{@first_name}, last_name=#{@last_name}, gender=#{@gender}, group=#{@group}, secs=#{@secs}"
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
   return self.mongo_client[:racers]
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
    prototype=prototype.symbolize_keys.slice(:number, :first_name, :last_name, :gender, :group, :secs) if !prototype.nil?

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

    bsonConverter = BSON.ObjectId(id)
    result=self.collection.find({:_id=> bsonConverter})
                          .projection({id:true, number:true, first_name:true, last_name:true, gender:true, group:true, secs:true })
                          .first
    #result=collection.find(:_id=>id)
    #              .projection({id:true, number:true, first_name:true, last_name:true, gender:true, group:true, secs:true })
    #              .first

    return result.nil? ? nil : Racer.new(result)
  end

  # create a new document using the current instance
  def save
    Rails.logger.debug {"saving #{self.to_s}"}
    #Rails.logger.debug {"saving racer num=#{@number}, first_name=#{@first_name}, last_name=#{@last_name}, gender=#{@gender}, group=#{@group}, secs=#{@secs}"}

    result=self.class.collection
              .insert_one( _id:@id,
                          number:@number,
                          first_name:@first_name,
                          last_name:@last_name,
                          gender:@gender,
                          group:@group,
                          secs:@secs)
    #@id=result[:_id].to_s
    @id=result.inserted_id.to_s

  end

  # update the values for this instance

  def update(params)
    Rails.logger.debug {"updating with #{self}"}

    @number=params[:number].to_i
    @first_name=params[:first_name]
    @last_name=params[:last_name]
    @gender=params[:gender]
    @group=params[:group]
    @secs=params[:secs].to_i

    #map internal :population term to :pop document term
    #params[:number]=params[:num]  if !params[:num].nil?
    params.slice!(:number, :first_name, :last_name, :gender, :group, :secs) if !params.nil?

    self.class.collection
              .find(_id:@id)
              .update_one(:$set=>params)

  end

  # remove the document associated with this instance form the DB
  def destroy
    Rails.logger.debug {"destroying #{self}"}

    self.class.collection
              .find(_id:@id)
              .delete_one
  end

end
