require 'rack'
require 'rack/server'
require 'pry'
require 'json'
require 'cgi/core'

class MyApp
  FILE = 'data.json'

  def response(env)
    verb = env['REQUEST_METHOD']
    response = (
      case verb
      when 'GET' then get(env)
      when 'POST' then post(env)
      else fail 'Not implemented'
      end
    )
    [200, {}, [response]]
  end

  def get(env)
    parsed_file[resource(env)].to_json
  end

  def resource(env)
    env['PATH_INFO'][1..-1] # remove first character which is a /
  end

  def post(env)
    input = env['rack.input'].read
    new_movie = CGI.parse(input)
    new_movie.each { |k, v| new_movie[k] = v.first }
    new_content = parsed_file.dup
    new_content[resource(env)].push(new_movie)
    write_file(new_content)
    'ok'
  end

  def parsed_file
    JSON.parse(File.read(FILE))
  end

  def write_file(content)
    File.write(FILE, content.to_json)
  end

  def self.call(env)
    MyApp.new.response(env)
  end
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Server.start :app => MyApp
end
