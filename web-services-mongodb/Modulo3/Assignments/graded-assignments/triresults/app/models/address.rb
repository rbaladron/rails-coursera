# This class handles processing the address format within the ingested JSON data.
# • provide read/write access to a city field of type String mapped to the document key of city
# • provide read/write access to a state field of type String mapped to the document key of state
# • provide read/write access to a location field of type Point mapped to the document key of loc
# • produce a MongoDB format consistent with the following:
#     {:city=>"(city)", :state=>"(state)", :loc=>(point)}
# • gracefully handle nil inputs, initializing internals to nil or returning nil where appropriate
class Address
  attr_accessor :city, :state, :location

  def initialize(city=nil, state=nil, location=nil)
    @city = city
    @state = state
    @location = location
  end

  #creates a DB-form of the instance
  	def mongoize
  		return {:city=>@city,:state=>@state,:loc=>Point.mongoize(@location)}
  	end

  	#creates an instance of the class from the DB-form of the data
  	def self.demongoize object
  		case object
  		when Hash then Address.new(object[:city], object[:state], Point.demongoize(object[:loc]))
  		else nil
  		end
  	end

  	#takes in all forms of the object and produces a DB-friendly form
  	def self.mongoize object
  		case object
  		when Address then object.mongoize
  		else object
  		end
  	end

  	def self.evolve(object)
  		case object
  		when Address then object.mongoize
  		else object
  		end
  	end
  end
