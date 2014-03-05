require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    #config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{Rails.root}/lib)
    #config.force_ssl = true
    config.i18n.enforce_available_locales = true
    config.assets.initialize_on_precompile = false if Rails.env.production?

    config.cache_store = :dalli_store if Rails.env.production?

    config.middleware.use Rack::Deflater if Rails.env.production?

    #config.active_record.whitelist_attributes = false
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end
  end
end
