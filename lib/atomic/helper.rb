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
        wrapped_block = nil

        if block.present?
          contents =  @view_context.capture(@view_context, &block)
          wrapped_block = Proc.new { contents }
        end

        @view_context.render(
          "#{@path}/#{method_name}",
          arguments: arguments,
          options: options,
          block: wrapped_block,
        )
      else
        @target.public_send(method_name, *arguments, **options, &block)
      end
    end
  end
end
