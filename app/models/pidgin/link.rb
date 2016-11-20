module Pidgin
  class Link
    extend Forwardable

    def_delegators :@definition,
                   :title,
                   :description,
                   :href,
                   :method,
                   :rel,
                   :schema,
                   :target_schema

    def initialize(definition)
      @definition = definition
    end

    def schema_hash
      return nil unless @definition.schema
      hash = @definition.schema.data.dup
      @definition.schema.properties.each do |key, value|
        hash['properties'][key] = value.data
      end
      type = @definition.schema.type
      hash['type'] = type.is_a?(Array) ? type.first : type
      hash
    end

    def status
      if @definition.method == :post
        if @definition.target_schema.present?
          201
        else
          204
        end
      else
        200
      end
    end

    def example_response
      if @definition.target_schema.present?
        @definition.target_schema.properties.each_with_object({}) do |(key, values), result|
          example = case values.type.first
                    when 'string'
                      'sample text'
                    end
          result[key] = example
        end
      else
        ''
      end
    end
  end
end

