module Atomic
  module ApplicationHelper
    def atomic
      Atomic::Helper.new(view_context: self, partial_path: "atomic")
    end

    def atomic_tag
      atomic.tag
    end
  end
end
