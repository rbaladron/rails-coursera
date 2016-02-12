json.array!(@movies) do |movie_action|
  json.extract! movie_action, :id, :title
  json.url movie_action_url(movie_action, format: :json)
end
