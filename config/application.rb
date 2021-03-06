require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie
require 'amazon/ecs' # 追記
# 外部ymlファイルから読み込み
#ENV.update YAML.load_file('config/secrets.yml')[Rails.env] rescue {}

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OriginalApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.time_zone = 'Tokyo'
    Amazon::Ecs.options = { 
      :associate_tag => 'stardy-22',
      :AWS_access_key_id => 'AKIAIL47C47MTYLX7HKA',
      :AWS_secret_key => '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', 
    }
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    #DBのタイムゾーン
    config.active_record.default_timezone = :local
  end
end
