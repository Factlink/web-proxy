environment :test do
  config[:host] = 'http://foo.invalid'
end

environment :development do
  config[:redirect_for_no_url] = 'https://localhost:3000/'
  config[:hostname] = 'localhost'
  config[:host] = 'http://localhost:4567'
  config[:jslib_uri] = 'http://localhost:8000/lib/dist/factlink_loader.js?o=proxy'
  config[:raven_dsn] = nil
end

config[:http_requester] = ->(url) { EM::HttpRequest.new(url).get }

