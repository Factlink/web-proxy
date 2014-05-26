# Factlink Web Proxy

[![Build Status](https://travis-ci.org/Factlink/web-proxy.svg?branch=master)](https://travis-ci.org/Factlink/web-proxy) [![Code Climate](https://codeclimate.com/github/Factlink/web-proxy.png)](https://codeclimate.com/github/Factlink/web-proxy) [![Code Climate](https://codeclimate.com/github/Factlink/web-proxy/coverage.png)](https://codeclimate.com/github/Factlink/web-proxy) [![Dependency Status](https://gemnasium.com/Factlink/web-proxy.svg)](https://gemnasium.com/Factlink/web-proxy)

Simple proxy which allows you to load any page on the internet, and inject the Factlink Javascript Library, to be able to share links comments on sites without Factlink enabled.

## Usage

To run locally, run `run.sh`, to run in docker, run using `run_in_docker.sh`.

## Deploying

The current deploy process is using Dokku. After pushing the app, some configuration still needs to be set. For example, when configuring for Factlink, this would be the following.

```bash
dokku config:set proxy-production redirect_for_no_url='https://factlink.com' \
  hostname='fct.li' \
  host='http://fct.li' \
  api_base_uri='https://factlink.com' \
  jslib_uri='https://static.factlink.com/lib/dist/factlink_loader.min.js?o=proxy' \
  APPSIGNAL_PUSH_API_KEY='...'
```

## Contributing

Currently this is very much a Factlink product. We recognize this would be interesting to use for other parties as well, and are very open to extract out the general portions of the code, so we can share that.

## License

Copyright (c) 2014 Factlink Inc. and individual contributors. Licensed under MIT license, see [LICENSE.txt](LICENSE.txt) for the full license.
