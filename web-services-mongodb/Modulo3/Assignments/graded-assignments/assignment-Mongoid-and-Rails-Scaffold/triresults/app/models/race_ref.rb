class RaceRef
  include Mongoid::Document
  field :n, as: :name, type: String
  field :date, as: :date, type: Date
end
