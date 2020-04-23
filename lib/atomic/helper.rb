module Atomic
  class Helper
    def initialize(view_context:, target: view_context)
      @view_context = view_context
      @target = target
    end

    def method_missing(method_name, *arguments, **options, &block)
      if @view_context.lookup_context.template_exists?("atomic/_#{method_name}")
        @view_context.render(
          "atomic/#{method_name}",
          arguments: arguments,
          options: options,
          block: block,
        )
      else
        @target.public_send(method_name, *arguments, **options, &block)
      end
    end
  end
end
