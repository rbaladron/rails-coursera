json.array!(@movies) do |movie|
  json.extract! movie, :id, :id, :title
  json.url movie_url(movie, format: :json)
end
