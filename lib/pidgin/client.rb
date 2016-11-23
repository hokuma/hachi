module Pidgin
  class Client
    class << self
      def klass
        @klass ||= begin
                     schema = Heroics::Schema.new(MultiJson.decode(open(::Pidgin::Config.schema_path).read))
                     eval Heroics.generate_client('::' + ::Pidgin::Config.client_class_name, schema, ::Pidgin::Config.endpoint, ::Pidgin::Config.headers)
                     ('::' + ::Pidgin::Config.client_class_name).constantize
                   end
      end
    end
  end
end
