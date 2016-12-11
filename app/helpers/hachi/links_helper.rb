module Hachi
  module LinksHelper
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
