module Pidgin
  class Resource
    extend Forwardable

    attr_accessor :id

    def_delegators :@definition, :title, :description
    class << self
      def find_all
        ::Pidgin::Schema.instance.definitions.map do |id, definition|
          new(id, definition)
        end
      end

      def find_by_id id
        ::Pidgin::Schema.instance.definitions[id]
      end
    end

    def initialize id, definition
      @id = id
      @definition = definition
    end
  end
end

