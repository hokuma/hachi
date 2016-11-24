module Pidgin
  class Link
    extend Forwardable

    def_delegators :@definition,
                   :title,
                   :description,
                   :href,
                   :method,
                   :parent,
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

    def path
      if @definition.href =~ /{/
        @definition.href.split('/').map do |dir|
          result = /{\((.+)\)}/.match(dir)
          if result
            decoded_path = URI.decode(result[1])
            identity_schema = Pidgin::Schema.instance.resolve_path(decoded_path)
            identities = identity_schema.data['anyOf'].map do |ref|
              result = /definitions\/(.+)\/definitions\/(.+)/.match(ref['$ref'])
              ":#{result[1]}_#{result[2]}"
            end.join('|')
          else
            dir
          end
        end.join('/')
      else
        @definition.href
      end
    end

    def resource_name
      self.parent.pointer.match(/definitions\/(.+)\z/)[1]
    end

    def send_request token, identity, payload
      client = ::Pidgin::Client.klass.connect_oauth(token)
      identity_args = self.path.split('/').each_with_object([]) do |dir, result|
        result << identity[dir]
      end.compact
      if identity_args.present? && @definition.schema.present?
        client.send(self.resource_name).send(self.title, *identity_args, payload)
      elsif identity_args.present?
        client.send(self.resource_name).send(self.title, *identity_args)
      elsif @definition.schema.present?
        client.send(self.resource_name).send(self.title, payload)
      else
        raise 'unsupported request interface'
      end
    end
  end
end

