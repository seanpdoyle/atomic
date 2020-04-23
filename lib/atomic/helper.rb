module Atomic
  class Helper
    def initialize(view_context:, target: view_context)
      @view_context = view_context
      @target = target
    end

    def h1(*arguments, **options, &block)
      if @view_context.lookup_context.template_exists?("atomic/_h1")
        @view_context.render(
          "atomic/h1",
          arguments: arguments,
          options: options,
          block: block,
        )
      else
        @target.h1(*arguments, **options, &block)
      end
    end
  end
end
