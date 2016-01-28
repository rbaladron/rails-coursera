require 'json'

class Place
  attr_accessor :id, :formatted_address, :location, :address_components

# Set the attributes from a has with keys
  def initialize(params)
    @id = params[:_id].to_s
    @formatted_address = params[:formatted_address]
    @location = Point.new(params[:geometry][:geolocation])

    @address_components = []
    if !params[:address_components].nil?
      address_components = params[:address_components]
      address_components.each { |a| @address_components << AddressComponent.new(a) }
    end

  end
  # returns a MongoDB Client from Mongoid referencing the
  # default database from the config/mongoid.yml file
  def self.mongo_client
    Mongoid::Clients.default
  end

  # returns a reference to the places collection
  def self.collection
    self.mongo_client[:places]
  end

  # will bulk load a JSON document with places information into
  # the places collection.
  def self.load_all(file_json)
    hash_file = JSON.parse(file_json.read)
    collection.insert_many(hash_file)
  end

  # that will return a Mongo::Collection::View with a
  # query to match documents with a matching short_name within
  # address_components
  def self.find_by_short_name(input_string)
    Place.collection.find({"address_components.short_name": input_string})
  end

  # accept a Mongo::Collection::View and return a
  # collection of Place instances.
  def self.to_places input_mongo
    p = []
    input_mongo.each { |m|
      p << Place.new(m)
    }
    return p
  end

  # return an instance of Place for a supplied id
  def self.find input_id
    _id = BSON::ObjectId.from_string(input_id)
    p = collection.find(:_id => _id).first
    if !p.nil?
      Place.new(p)
    else
      nil
    end
  end

  # return an instance of all documents as Place instances.
  def self.all(offset=0, limit=nil)
    if !limit.nil?
      docs = collection.find.skip(offset).limit(limit)
    else
      docs = collection.find.skip(offset)
    end

    docs.map { |doc|
      Place.new(doc)
    }
  end

  # delete the document associtiated
  # with its assigned id.
  def destroy
    self.class.collection.find(:_id => BSON::ObjectId.from_string(@id)).delete_one
  end

  # returns a collection of hash documents with
  # address_components and their associated _id, formatted_address and
  # location properties
  def self.get_address_components(sort=nil, offset=0, limit=nil)
    if sort.nil? and limit.nil?
      Place.collection.aggregate([
        {:$unwind => '$address_components'},
        {:$project => {
          :_id=>1,
          :address_components=>1,
          :formatted_address=>1,
          :geometry => {
            :geolocation => 1}}},
        {:$skip => offset}
      ])
    elsif sort.nil? and !limit.nil?
      Place.collection.aggregate([
        {:$unwind => '$address_components'},
        {:$project => {
          :_id=>1,
          :address_components=>1,
          :formatted_address=>1,
          :geometry => {
            :geolocation => 1}}},
        {:$skip => offset},
        {:$limit => limit}
      ])
    elsif !sort.nil? and limit.nil?
      Place.collection.aggregate([
        {:$unwind => '$address_components'},
        {:$project => {
          :_id=>1,
          :address_components=>1,
          :formatted_address=>1,
          :geometry => {
            :geolocation => 1}}},
        {:$sort => sort},
        {:$skip => offset}
      ])
    else
      Place.collection.aggregate([
        {:$unwind => '$address_components'},
        {:$project=>{
          :_id=>1,
          :address_components=>1,
          :formatted_address=>1,
          :geometry => {
            :geolocation => 1}}},
        {:$sort => sort},
        {:$skip => offset},
        {:$limit => limit}
      ])
    end
  end

  # returns a distinct collection of country names (long_names)
  def self.get_country_names
    Place.collection.aggregate([
      {:$unwind => '$address_components'},
      {:$project=>{
        :_id=>0,
        :address_components=> {
          :long_name => 1,
          :types => 1} }},
      {:$match => {'address_components.types': "country"  }},
      {:$group=>{
        :_id=>'$address_components.long_name',
        :count=>{:$sum=>1}}}
    ]).to_a.map {|h| h[:_id]}
  end

  # return the id of each document in
  # the places collection that has an address_component.short_name of type
  # country and matches the provided parameter.
  def self.find_ids_by_country_code(input_country)
    Place.collection.aggregate([
      {:$unwind => '$address_components'},
      {:$project=>{
        :_id=>1,
        :address_components=> {
        :short_name => 1,
        :types => 1} }},
      {:$match => {'address_components.short_name': input_country}}
    ]).map {|h| h[:_id].to_s}
  end

  # must make sure the 2dsphere index is in place for the
  # geometry.geolocation property
  def self.create_indexes
    Place.collection.indexes.
      create_one({'geometry.geolocation': Mongo::Index::GEO2DSPHERE})
  end

  # must make sure the 2dsphere index is removed from the collection
  def self.remove_indexes
    Place.collection.indexes.drop_one('geometry.geolocation_2dsphere')
  end

  # returns instances of places that are closest to provided Point
  def self.near(input_point, max_meters=nil)
    max_meters = max_meters.to_i if !max_meters.nil?

    if !max_meters.nil?
      Place.collection.find(
        {'geometry.geolocation':
         {'$near': input_point.to_hash, :$maxDistance => max_meters}})
    else
      Place.collection.find(
        {'geometry.geolocation':
         {'$near': input_point.to_hash}})
    end
  end

  # wraps the class method
  def near(max_meters=nil)
    max_meters = max_meters.to_i if !max_meters.nil?

    near_points = []
    if !max_meters.nil?
      Place.collection.find(
        {'geometry.geolocation':
         {'$near': @location.to_hash, :$maxDistance => max_meters}
        }
      ).each { |p|
        near_points << Place.new(p)
      }
    else
      Place.collection.find(
        {'geometry.geolocation':
         {'$near': @location.to_hash}}
      ).each { |p|
        near_points << Place.new(p)
      }
    end

    return near_points
  end

  # This method will return a collection of
  # Photos that have been associated with the place.
  def photos(offset=0, limit=0)
    self.class.mongo_client.database.fs.find(
      "metadata.place": BSON::ObjectId.from_string(@id)
    ).map { |photo|
      Photo.new(photo)
    }
  end

end
