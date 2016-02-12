class Movie
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  field :id, type: String
  field :title, type: String

  has_many :movie_accesses 
end
