require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock'
include WebMock::API

require 'mocha/test_unit'

module ActiveSupport
  class TestCase
    WebMock.enable!
  end
end
