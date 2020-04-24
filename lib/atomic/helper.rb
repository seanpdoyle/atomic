require_dependency "atomic/html_attributes"

module Atomic
  class Helper
    def initialize(view_context:, virtual_path:, partial_path:, target: view_context)
      @view_context = view_context
      @virtual_path = virtual_path
      @partial_path = partial_path
      @target = target
    end

    def component
      Atomic::Helper.new(
        view_context: @view_context,
        partial_path: File.join(@partial_path, "components"),
        virtual_path: @virtual_path,
      )
    end

    def tag
      Atomic::Helper.new(
        view_context: @view_context,
        virtual_path: @virtual_path,
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
      options = HtmlAttributes.new(arguments.extract_options!)

      if block.present?
        if block.arity.zero?
          contents = @view_context.capture(@view_context, &block)

          wrapped_block = proc { contents }
        else
          wrapped_block = proc do |*block_arguments|
            with_overridden_virtual_path { block.call(*block_arguments) }
          end
        end

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
          **options,
        },
        &wrapped_block
      )
    end

    def with_overridden_virtual_path
      original_virtual_path = @view_context.instance_variable_get(:@virtual_path)
      @view_context.instance_variable_set(:@virtual_path, @virtual_path)

      yield
    ensure
      @view_context.instance_variable_set(:@virtual_path, original_virtual_path)
    end
  end
end
