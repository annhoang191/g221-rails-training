require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"

Bundler.require(*Rails.groups)

module G221RailsTraining
  class Application < Rails::Application
    config.load_defaults 5.2
    config.api_only = true
    config.autoload_paths += %W(#{config.root}/lib)
  end
end
