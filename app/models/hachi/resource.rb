module Hachi
  class Resource
    extend Forwardable

    attr_accessor :id

    def_delegators :@definition, :title, :description, :properties, :required
    class << self
      def find_all
        ::Hachi::Schema.instance.definitions.map do |id, definition|
          new(id, definition)
        end
      end

      def find_by_id id
        new(id, ::Hachi::Schema.instance.definitions[id])
      end
    end

    def initialize id, definition
      @id = id
      @definition = definition
    end

    def links
      @links ||= begin
                   @definition.links.map do |link|
                     ::Hachi::Link.new(link)
                   end
                 end
    end
  end
end

