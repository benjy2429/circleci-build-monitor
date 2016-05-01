require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CircleciBuildMonitor
  class Application < Rails::Application

    config.poll_rate = ENV['POLL_RATE'] || 30

    config.circleci_url = 'https://circleci.com/cc.xml?circle-token='
    config.circleci_token = ENV['CIRCLECI_TOKEN']
  end
end
