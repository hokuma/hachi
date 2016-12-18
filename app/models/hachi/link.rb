module Hachi
  class Link
    extend Forwardable

    def_delegators :@definition,
                   :title,
                   :description,
                   :href,
                   :method,
                   :parent,
                   :rel,
                   :schema

    def initialize(definition)
      @definition = definition
    end

    def status
      if @definition.target_schema.present?
        if @definition.method == :post
          201
        else
          200
        end
      else
        200
      end
    end

    def route_path
      self.href.gsub(/\.json$/, '').slice(1..-1)
    end

    def path
      path_with_ext.gsub(/\.json$/, '')
    end

    def path_with_ext
      if @definition.href =~ /{/
          @definition.href.split('/').map do |dir|
          result = /{\((.+)\)}/.match(dir)
          if result
            decoded_path = URI.decode(result[1])
            identity_schema = Hachi::Schema.instance.resolve_path(decoded_path)
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

    def target_schema
      return @definition.target_schema if @definition.target_schema
      case @definition.rel
      when 'self'
        @definition.parent
      when 'instances'
      end
     end

    def resource_name
      self.parent.pointer.match(/definitions\/(.+)\z/)[1]
    end

    def send_authorization_request username, password, identity, payload, headers
      token = Base64.encode64("#{username}:#{password}")
      headers.merge!({ 'Authorization' => "Basic #{token}" })
      client = ::Hachi::Client.klass.connect(nil, { default_headers: headers })
      send_request client, identity, payload
    end

    def send_oauth_request token, identity, payload, headers
      client = ::Hachi::Client.klass.connect_oauth(token, { default_headers: headers })
      send_request client, identity, payload
    end

    def send_request client, identity, payload
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
        client.send(self.resource_name).send(self.title)
      end
    end
  end
end

