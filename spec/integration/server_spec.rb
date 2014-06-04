require 'spec_helper'
require_relative '../../server.rb'

describe Server do
  let(:http_requester) { double :http_requester }

  it "does a working proxy request for a page" do
    request_url = 'http://www.example.org/foo?bar=baz'

    url_html = <<-EOHTML.squeeze(' ').gsub(/^ /,'')
      <!DOCTYPE html>
      <html>
      <title>Hoi</title>
      <h1>yo</h1>
    EOHTML

    with_api(Server) do |server|
      mock_http_requests(server)
      expect(http_requester)
        .to receive(:call)
        .with(request_url, default_test_request_headers)
        .and_return mock_http_response(200, url_html)

      get_request(query: {url: request_url}) do |c|
        Approvals.verify(c.response, name: 'server_200')
      end
    end
  end

  it "does not proxy medium.com" do
    request_url = 'http://medium.com/foo?bar=baz'

    with_api(Server) do |server|
      mock_http_requests(server)

      get_request(query: {url: request_url}) do |c|
        Approvals.verify(c.response, name: 'blocked_site')
      end
    end
  end

  it "serves back a page with the same Content-Type and Content-Disposition" do
    request_url = 'http://www.example.org/foo?bar=baz'

    with_api(Server) do |server|
      mock_http_requests(server)
      expect(http_requester)
        .to receive(:call)
        .with(request_url, default_test_request_headers)
        .and_return mock_http_response(200, 'I am plain text', headers: {
          'Content-Type' => 'text/plain',
          'Content-Disposition' => 'attachment; filename="file.txt"; filename*=UTF-8''file.txt'
        })

      get_request(query: {url: request_url}) do |c|
        expect(c.response_header.status).to eq 200
        expect(c.response_header['Content-Type'])
          .to eq 'text/plain'
        expect(c.response_header['Content-Disposition'])
          .to eq 'attachment; filename="file.txt"; filename*=UTF-8''file.txt'
      end
    end
  end

  it "redirects you when it was redirected" do
    request_url = 'http://www.example.org/foo?bar=baz'

    with_api(Server) do |server|
      mock_http_requests(server)
      expect(http_requester)
        .to receive(:call)
        .with(request_url, default_test_request_headers)
        .and_return mock_http_response(301, '', headers: {
          'Location' => 'http://www.example.org/baz?foo=bar'
        })

      get_request(query: {url: request_url}) do |c|
        expect(c.response_header.status).to eq 301
        expect(c.response_header['Location'])
          .to eq 'http://foo.invalid/?url=http%3A%2F%2Fwww.example.org%2Fbaz%3Ffoo%3Dbar'
      end
    end
  end

  it "requests the proxied page with proxied user agent and language" do
    request_url = 'http://www.example.org/foo?bar=baz'

    url_html = <<-EOHTML.squeeze(' ').gsub(/^ /,'')
      <!DOCTYPE html>
      <html>
      <title>Hoi</title>
      <h1>yo</h1>
    EOHTML

    modified_headers = {
      'Accept-Language' => 'i-klingon',
      'User-Agent' => 'NCSA_Mosaic/2.0 '
    }

    with_api(Server) do |server|
      mock_http_requests(server)
      expect(http_requester)
        .to receive(:call)
        .with(request_url, modified_headers)
        .and_return mock_http_response(200, url_html)

      get_request(query: {url: request_url}, head: modified_headers) { |c| nil }
    end

  end

  it "redirects to a specified url when no url has been provided" do
    with_api(Server) do |server|
      backup_url = "http://someurl.example.org/"
      server.config[:redirect_for_no_url] = backup_url

      get_request(path: '/') do |c|
        expect(c.response_header.status).to eq 301
        expect(c.response_header['Location']).to eq "http://someurl.example.org/"
      end
    end
  end
end
