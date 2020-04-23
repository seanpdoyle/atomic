module Atomic
  module ApplicationHelper
    def atomic_tag
      Atomic::Helper.new(view_context: self, virtual_path: @virtual_path, target: tag)
    end

    def atomic
      Atomic::Helper.new(view_context: self, virtual_path: @virtual_path)
    end
  end
end
