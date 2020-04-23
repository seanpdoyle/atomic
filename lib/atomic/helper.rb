module Atomic
  class Helper
    def initialize(view_context:, target: view_context, path: "atomic")
      @view_context = view_context
      @target = target
      @path = path
    end

    def component
      Atomic::Helper.new(
        view_context: @view_context,
        path: File.join(@path, "components"),
      )
    end

    def method_missing(method_name, *arguments, **options, &block)
      if @view_context.lookup_context.template_exists?("#{@path}/_#{method_name}")
        render("#{@path}/#{method_name}", *arguments, **options, &block)
      else
        @target.public_send(method_name, *arguments, **options, &block)
      end
    end

    private

    def render(partial_name, *arguments, **options, &block)
      original_virtual_path = @view_context.instance_variable_get(:@virtual_path)
      @virtual_path = original_virtual_path

      if block.present?
        if block.arity > 0
          wrapped_block = block
        else
          content = @view_context.capture(self, &block)

          wrapped_block = Proc.new { content }
        end

        @view_context.render(
          layout: partial_name,
          locals: {
            arguments: arguments,
            options: options,
            block: wrapped_block,
          },
          &wrapped_block
        )
      else
        @view_context.render(
          partial: partial_name,
          locals: {
            arguments: arguments,
            options: options,
            block: nil,
          },
        )
      end
    ensure
      @virtual_path = nil
    end
  end
end
