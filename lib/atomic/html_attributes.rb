module Atomic
  class HtmlAttributes
    delegate_missing_to :@attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def with_token_list_defaults(options)
      merge(convert_options_to_token_lists!(options))
    end

    def to_h
      @attributes.to_h
    end

    def to_hash
      @attributes.to_hash
    end

    private

    def convert_options_to_token_lists!(options)
      options.reduce({}) do |token_lists, (key, value)|
        tokens = Array(@attributes.delete(key))

        tokens = tokens.flat_map { |token| token.split(" ") }

        converted_token_list = tokens.push(value).flatten

        token_lists.merge(key => converted_token_list.uniq)
      end
    end
  end
end
