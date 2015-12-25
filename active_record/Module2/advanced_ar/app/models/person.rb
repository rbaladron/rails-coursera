class Person < ActiveRecord::Base
  has_one :personal_info
  has_many :jobs
end
