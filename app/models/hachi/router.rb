module Hachi
  class Router
    def initialize schema
      @routes = build_routes(schema)
    end

    # [method, href] -> definition
    def build_routes schema
      schema.definitions.each_with_object({}) do |(resource_name, definition), routes|
        definition.links.each do |link|
          key = [method = link['method'], href = URI.decode(link['href'])]
          routes[key] = link
        end
      end
    end

    def find_by method:, href:
      @routes[[method.to_sym, URI.decode('/' + href)]]
    end
  end
end
