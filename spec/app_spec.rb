require 'pry'
require 'json'
require 'rack/test'

ENV['RACK_ENV'] = 'test'
require_relative '../app'

include Rack::Test::Methods

def app
  MyApp
end

def parsed_body
  body = last_response.body
  JSON.parse(body)
end

# First test to see that it works
describe 'my_app' do

  after(:each) do
    FileUtils.copy('data.json.orig', 'data.json')
  end

  describe 'GET /movies' do
    it 'should return 6 movies' do
      get '/movies'
      expect(parsed_body.count).to eq(6)
    end
  end

  describe 'GET /directors' do
    it 'should return 3 directors' do
      get '/directors'
      expect(parsed_body.count).to eq(3)
    end
  end

  describe 'POST /movies' do
    let(:movie) { { title: 'My Super Movie', year: 2016, directory_id: 1 } }

    it 'is successful' do
      post '/movies', movie
      last_response.ok?
    end

    it 'adds a movie' do
      post '/movies', movie
      get '/movies'
      expect(parsed_body.count).to eq(7)
    end
  end

  describe 'POST /directors' do
    let(:director) { { 'name' => 'David Me' } }

    it 'is successful' do
      post '/directors', director
      last_response.ok?
    end

    it 'adds a director' do
      post '/directors', director
      get '/directors'
      expect(parsed_body.count).to eq(4)
    end

    it 'adds the correct director' do
      post '/directors', director
      get '/directors'
      expect(parsed_body.last).to eq(director)
    end
  end
end
