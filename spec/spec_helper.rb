require 'rack/test'
require File.expand_path('../../lib/rack-canonical_link', __FILE__)


def app
  Rack::Lint.new(mock_app)
end
def main_app
  lambda { |env|
    request = Rack::Request.new(env)
    case request.path
      when '/' then
        [200, {'Content-Type' => 'application/html; charset=utf-8'}, ['<html><head>Hello world</head><body></body></html>']]
      when '/text.html' then
        [200, {'Content-Type' => ' text/html; charset=utf-8'}, ['<html><head>Hello world</head><body></body></html>']]
      when '/test.xml' then
        [200, {'Content-Type' => 'application/xml'}, ['<head></head><xml></xml>']]
      when '/bob' then
        [200, {'Content-Type' => 'application/html'}, ['<body>bob here</body>']]
      else
        [404, 'Nothing here']
    end
  }
end

def mock_app()
  return @app unless @app.nil?
  @app = Rack::Builder.app do
    use Rack::CanonicalLink
    run main_app
  end
end
