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

      if block.present?
        contents =  @view_context.capture(@view_context, &block)
        wrapped_block = Proc.new { contents }

        template_key = :layout
      else
        wrapped_block = nil

        template_key = :partial
      end

      @view_context.render(
        template_key => partial_name,
        locals: {
          arguments: arguments,
          options: options,
          block: wrapped_block,
        },
        &wrapped_block
      )
    end
  end
end
