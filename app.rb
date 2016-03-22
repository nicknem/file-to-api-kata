require 'rack'
require 'rack/server'
require 'pry'
require 'json'

class MyApp
  def response(env)
    resource = env['PATH_INFO'][1..-1] #remove first character which is a /
    json = JSON.parse(File.read('data.json'))[resource].to_json
    [200, {}, [json]]
  end
  def self.call(env)
    MyApp.new.response(env)
  end
end

Rack::Server.start :app => MyApp
