require_dependency "atomic/html_attributes"

module Atomic
  class Fallback
    def initialize(target, method_name, *arguments, &block)
      @target = target
      @method_name = method_name
      @arguments = arguments
      @options = HtmlAttributes.new(arguments.extract_options!)
      @block = block
    end

    def call
      @target.public_send(
        @method_name,
        *@arguments,
        **@options,
        &@block
      )
    end

    def with_token_list_defaults(attributes)
      clone(@options.with_token_list_defaults(attributes))
    end

    def with_defaults(attributes)
      clone(@options.with_defaults(attributes))
    end

    def to_s
      call
    end

    def inspect
      "<#{self.class} #{instance_variables}>"
    end

    private

    def clone(overrides)
      overridden_arguments = @arguments.append(@options.merge(overrides))

      Atomic::Fallback.new(
        @target,
        @method_name,
        *overridden_arguments,
        &@block
      )
    end
  end
end
