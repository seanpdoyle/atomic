module Atomic
  module ApplicationHelper
    def atomic_tag
      Atomic::Helper.new(view_context: self, target: tag)
    end
  end
end
