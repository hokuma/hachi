module Pidgin
  class Config
    include ActiveSupport::Configurable

    config_accessor :schema_path

    configure do |config|
      config.schema_path = 'your api schema path'
    end
  end
end
