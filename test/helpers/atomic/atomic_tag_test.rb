require "atomic_test_case"

module Atomic
  class AtomicTagTest < AtomicTestCase
    test "falls back to Rails defaults" do
      declare_template "comments/show", <<~ERB
        <%= atomic_tag.h1 class: "rails-h1" do %>
          Title From Atomic
        <% end %>
      ERB

      render "comments/show"

      assert_select %(h1[class="rails-h1"]), text: "Title From Atomic", count: 1
    end

    test "renders a template when available" do
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

    test "makes options available to the template" do
      declare_template "comments/show", <<~ERB
        <%= atomic_tag.h1 class: "from-template" do %>
          Title From Atomic
        <% end %>
      ERB
      declare_template "atomic/tags/_h1", <<~'ERB'
        <%= tag.h1(*arguments, class: "from-partial #{options.delete(:class)}", **options, &block) %>
      ERB

      render "comments/show"

      assert_select %(h1[class="from-partial from-template"]), text: "Title From Atomic"
    end
  end
end
