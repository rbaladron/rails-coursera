class Racer
  include ActiveModel::Model

  # convenience method for access to client in console
  def self.mongo_client
   Mongoid::Clients.default
  end

  # convenience method for access to racers collection
  def self.collection
   self.mongo_client['racers']
  end
end
