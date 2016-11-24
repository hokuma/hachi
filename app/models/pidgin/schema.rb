module Pidgin
  class Schema
    include Singleton

    def initialize
      @schema = load_schema
      @router = Router.new(@schema)
      @evaluator = JsonPointer::Evaluator.new(@schema)
    end

    def load_schema
      json_data = JSON.parse(File.read(Pidgin::Config.schema_path))
      schema = JsonSchema.parse!(json_data)
      schema.expand_references!
      schema
    end

    def definitions
      @schema.definitions
    end

    def resolve_path(path)
      @evaluator.evaluate(path)
    end

    def get_link method, href
      Link.new(@router.find_by(method: method, href: href))
    end
  end
end

