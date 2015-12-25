class Job < ActiveRecord::Base
  belongs_to :person
  has_one :salary_range
end
