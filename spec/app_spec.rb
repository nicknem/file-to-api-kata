require 'pry'
require 'json'
require "rack/test"
require_relative '../app'
include Rack::Test::Methods

def app
  MyApp
end

# First test to see that it works
describe 'my_app' do
  describe 'get/movies' do
    it 'should return 6 movies' do
      get '/movies'
      body = last_response.body
      expect(JSON.parse(body).count).to eq(6)
    end
  end
  describe 'get/directors' do
    it 'should return 3 directors' do
      get '/directors'
      body = last_response.body
      expect(JSON.parse(body).count).to eq(3)
    end
  end

end
