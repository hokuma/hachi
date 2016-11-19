module Pidgin
  class Router
    def initialize schema
      @routes = build_routes(schema)
    end

    # [method, path] -> definition
    def build_routes schema
      schema.definitions.each_with_object({}) do |(resource_name, definition), routes|
        definition.links.each do |link|
          key = [method = link['method'], path = link['href']]
          routes[key] = definition
        end
      end
    end
  end
end
