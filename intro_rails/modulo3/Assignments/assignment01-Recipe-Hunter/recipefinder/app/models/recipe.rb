require 'httparty'
ENV['FOOD2FORK_KEY'] = '68be1e178c6e86547d2e09ba32512a7f'

class Recipe < ActiveRecord::Base
  include HTTParty

  key_value = ENV['FOOD2FORK_KEY']
  hostport = ENV['FOOD2FORK_SERVER_AND_PORT'] || 'www.food2fork.com'
  base_uri "http://#{hostport}/api/search"
  default_params key: key_value
  format :json


  def self.for search_term_param
    get(query: {q: search_term_param}) ['recipe']
  end
end
