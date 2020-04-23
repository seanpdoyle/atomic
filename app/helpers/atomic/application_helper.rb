module Atomic
  module ApplicationHelper
    def atomic
      Atomic::Helper.new(view_context: self, virtual_path: @virtual_path)
    end

    def atomic_tag
      atomic.tag
    end
  end
end
