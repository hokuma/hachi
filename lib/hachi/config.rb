module Hachi
  class Config
    include ActiveSupport::Configurable

    config_accessor :client_class_name,
                    :endpoint,
                    :headers,
                    :schema_path

    configure do |config|
      config.client_class_name = 'SampleApiClient'
      config.endpoint = 'http://localhost:3000'
      config.headers = {
        'X-API-VERSION': '1',
      }
      config.schema_path = 'your api schema path'
    end
  end
end
