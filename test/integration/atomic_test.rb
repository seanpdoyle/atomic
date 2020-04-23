require "test_helper"

class AtomicTest < ActiveSupport::TestCase
  include Rails::Dom::Testing::Assertions

  test "atomic_tag falls back to Rails defaults when a template is not specified" do
    declare_template "comments/show", <<~ERB
      <%= atomic_tag.h1 do %>
        Title From Atomic
      <% end %>
    ERB

    render "comments/show"

    assert_select %(h1), text: "Title From Atomic", count: 1
  end

  test "atomic_tag renders a template when available" do
    declare_template "comments/show", <<~ERB
      <%= atomic_tag.h1 do %>
        Title From Atomic
      <% end %>

      <%= atomic_tag.p do %>
        Body From Atomic
      <% end %>
    ERB
    declare_template "atomic/tags/_h1", <<~ERB
      <%= tag.h1(*arguments, class: "atomic-h1", **options, &block) %>
    ERB
    declare_template "atomic/tags/_p", <<~ERB
      <%= tag.p(*arguments, class: "atomic-p", **options, &block) %>
    ERB

    render "comments/show"

    assert_select %(h1[class="atomic-h1"]), text: "Title From Atomic", count: 1
    assert_select %(p[class="atomic-p"]), text: "Body From Atomic", count: 1
  end

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
