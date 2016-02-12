class CachedWS
  include HTTParty
#  include HTTParty::DryIce
  debug_output $stdout
  base_uri "http://localhost:3000"
#  cache Rails.cache
end
