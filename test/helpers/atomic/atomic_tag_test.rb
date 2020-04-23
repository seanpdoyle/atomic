require "atomic_test_case"

module Atomic
  class AtomicTagTest < AtomicTestCase
    test "falls back to Rails defaults" do
      declare_template "users/show", <<~ERB
        <%= atomic_tag.h1 class: "rails-h1" do %>
          Title From Atomic
        <% end %>
      ERB

      render "users/show"

      assert_select %(h1[class="rails-h1"]), text: "Title From Atomic"
    end

    test "renders a template when available" do
      declare_template "users/show", <<~ERB
        <%= atomic_tag.h1 do %>
          Title From Atomic
        <% end %>

        <%= atomic_tag.p do %>
          Body From Atomic
        <% end %>
      ERB
      declare_template "atomic/_h1", <<~ERB
        <%= tag.h1(*arguments, class: "atomic-h1", **options, &block) %>
      ERB
      declare_template "atomic/_p", <<~ERB
        <%= tag.p(*arguments, class: "atomic-p", **options, &block) %>
      ERB

      render "users/show"

      assert_select %(h1[class="atomic-h1"]), text: "Title From Atomic"
      assert_select %(p[class="atomic-p"]), text: "Body From Atomic"
    end
  end
end
