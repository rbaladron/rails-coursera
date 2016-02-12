json.array!(@movies) do |movie_page|
  json.extract! movie_page, :id, :title
  json.url movie_page_url(movie_page, format: :json)
end
