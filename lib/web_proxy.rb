require_relative './html_editor'
require_relative './url_validator'

class WebProxy < Goliath::API
  def response(env)
    req = Rack::Request.new(env)
    requested_url = req.params['url']

    if !requested_url.include?('//')
      requested_url = 'http://' + requested_url
    end

    url_validator = UrlValidator.new(requested_url)
    if !url_validator.valid?
      invalid_request
    elsif url_validator.blocked?
      respond_by_placeholder(env, url_validator.normalized)
    else
      respond_by_proxy(env, url_validator.normalized)
    end
  end

  def respond_by_proxy(env, requested_url)
    page = retrieve_page(env, requested_url)

    case page.response_header.status
    when 200..299, 400..599
      [
        page.response_header.status,
        {"X-Proxied-Location" => requested_url},
        set_base(requested_url, page.response)
      ]
    when 300..399
      location = proxied_location(env, page.response_header['Location'])
      [
        page.response_header.status,
        { 'Location' => location },
        %Q(Redirecting to <a href="#{location}">#{location}</a>)
      ]
    when 0
      [
        504,
        {},
        "This page is taking unusually long to load. You can try visiting the site without Factlink: <a href='#{requested_url}'>#{requested_url}</a>"
      ]
    else
      fail "unknown status #{page.response_header.status}"
    end
  end

  def respond_by_placeholder(env, requested_url)
    [
      203,
      {"X-Proxied-Location" => requested_url},
      "<!DOCTYPE html><title>Content blocked</title><p style='font:200% sans-serif ;text-align:center;margin:3em 2em;color:#666'>The content of this site has been blocked at request of the site owner.</p>"
    ]
  end

  def set_base(requested_url, html)
    escaped_url = CGI.escapeHTML(requested_url)
    new_base_tag = "<base href=\"#{escaped_url}\" />"

    HtmlEditor.prepend_to_head(html,new_base_tag)
  end

  def proxied_location(env, location)
    env.config[:host] + '/?url=' + CGI.escape(location)
  end

  def retrieve_page(env, url)
    env.config[:http_requester].call(url, proxied_headers(env))
  end

  def proxied_headers(env)
    [
      'Accept-Language',
      'User-Agent',
    ].each_with_object({}) do |key, header|
      # WARNING: conversion is strongly coupled with Goliaths implementation:
      # https://github.com/postrank-labs/goliath/blob/v1.0.3/lib/goliath/request.rb#L77
      rack_key = Goliath::Constants::HTTP_PREFIX + key.gsub('-','_').upcase
      header[key] = env[rack_key] if env.key?(rack_key)
    end
  end

  def invalid_request
    [500, {}, 'Request was invalid, invalid url']
  end
end
