require 'appsignal'

Appsignal.config =
  Appsignal::Config.new(ENV['PWD'], Goliath.env, name: "Factlink Proxy")
Appsignal.start_logger(nil)
Appsignal.start if Appsignal.active?

class AppsignalGoliathListener
  include Goliath::Rack::AsyncMiddleware

  def post_process(env, status, headers, body)
    if Appsignal.active? && env['rack.exception']
      Appsignal.send_exception(env['rack.exception'])
    end

    [status, headers, body]
  end
end
