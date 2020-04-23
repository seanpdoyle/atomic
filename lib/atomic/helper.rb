module Atomic
  class Helper
    def initialize(view_context:, target: view_context)
      @view_context = view_context
      @target = target
    end

    def h1(*arguments, **options, &block)
      @target.h1(*arguments, **options, &block)
    end
  end
end
