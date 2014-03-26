# Factlink Web Proxy [![Code Climate](https://codeclimate.com/github/Factlink/web-proxy.png)](https://codeclimate.com/github/Factlink/web-proxy) [![Build Status](https://circleci.com/gh/Factlink/web-proxy.png?circle-token=433d315298235b0c2fbf7b2670a92a8)(https://circleci.com/gh/Factlink/web-proxy)]

Simple proxy which allows you to load any page on the internet, and inject the Factlink Javascript Library, to be able to share links comments on sites without Factlink enabled.

## Usage

To run locally, run `run.sh`, to run in docker, run using `run_in_docker.sh`.

## Deploying

The current deploy process is using Dokku. After pushing the app, some configuration still needs to be set. For example, when configuring for Factlink, this would be the following.

```bash
dokku config:set proxy-production redirect_for_no_url='https://factlink.com' \
  hostname='fct.li' \
  host='http://fct.li' \
  jslib_uri='https://static.factlink.com/lib/dist/factlink_loader.min.js?o=proxy' \
  raven_dsn='...'
```

## Contributing

Currently this is very much a Factlink product. We recognize this would be interesting to use for other parties as well, and are very open to extract out the general portions of the code, so we can share that.

If you want to try out

## License

Copyright (c) 2014 Factlink Inc and individual contributers, MIT license

