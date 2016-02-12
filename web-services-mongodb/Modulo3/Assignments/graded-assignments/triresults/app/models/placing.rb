# IThis class  handles processing the placing format within the ingested JSON data.
# • provide read/write access to a name field of type String mapped to the document key of name
# • provide read/write access to a place field of type Integer mapped to the document key of place
# • produce a MongoDB format consistent with the following format:
#   {:name=>"(category name)" :place=>"(ordinal placing)"}
# • gracefully handle nil inputs, initializing internals to nil or returning nil where appropriate
class Placing
  attr_accessor :name, :place

  def initialize(name, place)
    @name = name
    @place = place
  end

  #creates a DB-form of the instance
  def mongoize
    {:name => @name, :place=>@place}
  end

  #creates an instance of the class from the DB-form of the data
  def self.demongoize(object)
    case object
    when Hash
      Placing.new(object[:name], object[:place])
    when nil
      nil
    end
  end

  #takes in all forms of the object and produces a DB-friendly form
  def self.mongoize(object)
    case object
    when Placing then object.mongoize
    when Hash then
      Placing.new(object[:name], object[:place]).mongoize
    else object
    end
  end

  #used by criteria to convert object to DB-friendly form
  def self.evolve(object)
    case object
    when Placing then object.mongoize
    else object
    end
  end

end
