class Movie
  include Mongoid::Document
  field :title, type: String
  field :last_modifier, type: String
end
