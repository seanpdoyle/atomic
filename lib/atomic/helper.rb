module Atomic
  class Helper
    def initialize(view_context:)
      @view_context = view_context
    end

    def method_missing(method_name, *arguments, &block)
      if @view_context.lookup_context.template_exists?("atomic/tags/_#{method_name}")
        options = arguments.extract_options!

        @view_context.render(
          "atomic/tags/#{method_name}",
          arguments: arguments,
          options: options,
          block: block,
        )
      elsif @view_context.tag.respond_to?(method_name)
        @view_context.tag.public_send(method_name, *arguments, &block)
      else
        super
      end
    end
  end
end
