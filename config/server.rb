environment :test do
  config[:host] = 'http://foo.invalid'
end

environment :development do
  config[:redirect_for_no_url] = 'http://localhost:3000/'
  config[:hostname] = 'localhost'
  config[:host] = 'http://localhost:4567'
  config[:jslib_uri] = 'http://localhost:8000/lib/dist/factlink_loader.js?o=proxy'
end

[:redirect_for_no_url, :hostname, :host, :jslib_uri, :raven_dsn].each do |var|
  config[var] = ENV[var.to_s] if ENV.key? var.to_s
end

config[:http_requester] = ->(url) { EM::HttpRequest.new(url).get }
