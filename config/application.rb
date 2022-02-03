require_relative "boot"

require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "active_job/railtie"

Bundler.require(*Rails.groups)

module ShippingLabelsApi
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.active_job.queue_adapter = :resque
    config.active_job.queue_name_prefix = Rails.env
  end
end
