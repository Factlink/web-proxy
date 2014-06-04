require 'bundler'
Bundler.setup

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'goliath/test_helper'
require 'approvals'
require 'hashie'
require_relative './helper_methods'

Goliath.env = :test

RSpec.configure do |c|
  c.include Goliath::TestHelper,
    file_path: /spec\/integration/

  c.include HelperMethods
end
