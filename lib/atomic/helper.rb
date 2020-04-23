module Atomic
  class Helper
    def initialize(view_context:)
      @view_context = view_context
    end

    def h1(*arguments, &block)
      @view_context.h1(*arguments, &block)
    end
  end
end
