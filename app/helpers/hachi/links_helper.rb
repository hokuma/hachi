module Hachi
  module LinksHelper
    def example_response schema
      if schema.data['example']
        schema.data['example']
      elsif schema.type.include?('object')
        schema.properties.each_with_object({}) do |(key, property), example|
          example[key] = example_response(property)
        end
      elsif schema.type.include?('array')
        [example_response(schema.items)]
      end
    end

    def schema_to_hash data
      if data['properties'].present?
        data['properties'].each do |key, value|
          data['properties'][key] = schema_to_hash(value)
        end
      elsif data['items'].present?
        data['items'] = schema_to_hash(data['items'])
      end
      type = data['type']
      data['type'] = type.is_a?(Array) ? type.first : type
      data
    end
  end
end
