
mongo_client = Mongoid::Clients.default

# Clear GridFS of all files
Rails.logger.debug {"Populating Data Base: Clear photos"}
Photo.mongo_client.database.fs.find.each { |photo|
  id_photo = photo[:_id].to_s
  p = Photo.find(id_photo)
  p.destroy
}

# Clear the places collection of all documents
Rails.logger.debug {"Populating Data Base: Clear places"}
mongo_client[:places].delete_many()


# Make sure the 2dsphere index has been created for the nested geometry.geolocation
# property within the places collection.
Rails.logger.debug {"Populating Data Base: Create index"}
mongo_client[:places].indexes.create_one(
  {'geometry.geolocation': Mongo::Index::GEO2DSPHERE}
)

# Populate the places collection
Rails.logger.debug {"Populating Data Base: Load places"}
place_file = File.open("./db/places.json")
Place.load_all(place_file)

# Populate GridFS with the images
Rails.logger.debug {"Populating Data Base: Load photos"}
Dir.glob("./db/image*.jpg").each { |file_name|
  p = Photo.new
  f = File.open(file_name)
  f.rewind
  p.contents = f
  id = p.save
}
# For each photo in GridFS, locate the nearest place within one (1) mile of each
# photo and associated the photo with that place
Rails.logger.debug {"Populating Data Base: Match photo with place"}
Photo.all.each { |photo|
  place_id = photo.find_nearest_place_id(1609.34)
  photo_id = photo.id.to_s
  p = Photo.find(photo_id)
  p.place = place_id
  p.save
}
