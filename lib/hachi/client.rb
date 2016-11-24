module Hachi
  class Client
    class << self
      def klass
        @klass ||= begin
                     schema = Heroics::Schema.new(MultiJson.decode(open(::Hachi::Config.schema_path).read))
                     eval Heroics.generate_client('::' + ::Hachi::Config.client_class_name, schema, ::Hachi::Config.endpoint, ::Hachi::Config.headers)
                     ('::' + ::Hachi::Config.client_class_name).constantize
                   end
      end
    end
  end
end
