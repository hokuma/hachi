module Pidgin
  class Schema
    class << self
      def load_schema
        json_data = JSON.parse(File.read(Pidgin::Config.schema_path))
        schema = JsonSchema.parse!(json_data)
        schema.expand_references!
        schema
      end

      def fetch
        @instance ||= load_schema
      end
    end

    def initialize schema
      @schema = schema
      @router = Router.new(schema)
    end

    def definitions
      @schema.definitions
    end

    def find_definition_from_request method, path
      @router[[method, path]]
    end
  end
end

