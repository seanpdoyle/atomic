module Atomic
  class Helper
    def initialize(view_context:, partial_path:, target: view_context)
      @view_context = view_context
      @partial_path = partial_path
      @target = target
    end

    def tag
      Atomic::Helper.new(
        view_context: @view_context,
        partial_path: File.join(@partial_path, "tags"),
        target: @view_context.tag,
      )
    end

    def method_missing(method_name, *arguments, &block)
      if @view_context.lookup_context.template_exists?("#{@partial_path}/_#{method_name}")
        render("#{@partial_path}/#{method_name}", *arguments, &block)
      elsif @target.respond_to?(method_name)
        @target.public_send(method_name, *arguments, &block)
      else
        super
      end
    end

    private

    def render(partial_name, *arguments, &block)
      options = arguments.extract_options!

      @view_context.render(
        partial_name,
        arguments: arguments,
        options: options,
        block: block,
      )
    end
  end
end
