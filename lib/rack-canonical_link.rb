require "rack-canonical_link/version"

module Rack
  class CanonicalLink
    def initialize(app)
      @app = app
    end

    def call(env)
      @status, @headers, @body = @app.call(env)
      
      if env['rack.url_scheme'] != 'https' && (@headers['Content-Type'] =~ /application\/html/ || @headers['Content-Type'] =~ /text\/html/)
        request = Rack::Request.new env
        new_body = []
        
        @body.each {|fragement| new_body << fragement.gsub(%r{</head>}, '<link href="' + request.url.gsub(/\/$/,'') + '" rel="canonical" /></head>') } 
        @body = new_body
      end

      [@status, @headers, @body]
    end
  end
end
