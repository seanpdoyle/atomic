require "test_helper"

class AtomicTestCase < ActiveSupport::TestCase
  include Rails::Dom::Testing::Assertions

  def around(&block)
    Dir.mktmpdir do |temporary_directory|
      @partial_path = Pathname(temporary_directory).join("app", "views")

      with_view_path_prefixes(@partial_path) do
        block.call
      end
    end
  end

  def render(*arguments, **options, &block)
    ApplicationController.render(*arguments, **options, &block).tap do |rendered|
      @document_root_element = Nokogiri::HTML(rendered)
    end
  end

  def document_root_element
    if @document_root_element.nil?
      raise "Don't forget to call `render`"
    end

    @document_root_element
  end

  def declare_template(path, html)
    @partial_path.join("#{path}.html.erb").tap do |file|
      file.dirname.mkpath

      file.write(html)
    end
  end

  def with_view_path_prefixes(temporary_view_directory, &block)
    view_paths = ActionController::Base.view_paths

    ActionController::Base.prepend_view_path(temporary_view_directory)

    block.call
  ensure
    ActionController::Base.view_paths = view_paths
  end
end
