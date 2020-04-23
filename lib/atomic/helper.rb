module Atomic
  class Helper
    def initialize(view_context:)
      @view_context = view_context
    end

    def h1(*arguments, &block)
      if @view_context.lookup_context.template_exists?("atomic/tags/_h1")
        options = arguments.extract_options!

        @view_context.render(
          "atomic/tags/h1",
          arguments: arguments,
          options: options,
          block: block,
        )
      else
        @view_context.tag.h1(*arguments, &block)
      end
    end
  end
end
