class MovieAccess
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :accessed_by, type: String
  field :action, type: String

  belongs_to :movie
end
