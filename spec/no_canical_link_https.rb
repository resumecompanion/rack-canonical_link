require 'spec_helper'

module Rack
  describe CanonicalLink do
    include Rack::Test::Methods
    it 'should not inject canonical tag into head of https HTML request' do
      get('https://example.org/').body.should == '<html><head>Hello world</head><body></body></html>'
    end

    it 'should inject canonical tag into head of http HTML request for text/html' do
      get('http://example.org/text.html').body.should == '<html><head>Hello world<link href="http://example.org/text.html" rel="canonical" /></head><body></body></html>'
    end

    it 'should inject canonical tag of http HTML request' do
      get('/').body.should == '<html><head>Hello world<link href="http://example.org" rel="canonical" /></head><body></body></html>'
    end

    it 'should not inject canonical tag into non HTML requests for HTTP' do
      get('/test.xml').body.should == '<head></head><xml></xml>'
    end

    it 'should not inject no canonical tag into non HTML requests for HTTPS' do
      get('https://example.org/test.xml').body.should == '<head></head><xml></xml>'
    end
  end
end
