#!/bin/bash
bundle install
bundle exec ruby server.rb -p 8080 -e development
