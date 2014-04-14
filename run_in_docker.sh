#!/bin/bash
docker run -d \
  -v ~/dev/factlink/ruby-web-proxy:/webproxy \
  -p 8080:8080 \
  -w /webproxy \
  d11wtq/ruby \
  ./run.sh

