require "atomic_test_case"

module Atomic
  class AtomicTest < AtomicTestCase
    test "falls back to Rails defaults" do
      declare_template "users/show", <<~ERB
        <%= atomic.link_to "#", class: "link" do %>
          Link From Rails
        <% end %>
      ERB

      render "users/show"

      assert_select %(a[href="#"][class="link"]), text: "Link From Rails"
    end

    test "renders a template when available" do
      declare_template "users/show", <<~ERB
        <%= atomic.link_to "#" do %>
          Link From Atomic
        <% end %>

        <%= atomic.image_tag "image.jpg" %>
      ERB
      declare_template "atomic/_link_to", <<~ERB
        <%= link_to(*arguments, class: "atomic-link", **options, &block) %>
      ERB
      declare_template "atomic/_image_tag", <<~ERB
        <%= image_tag(*arguments, class: "atomic-img", **options) %>
      ERB

      render "users/show"

      assert_select %(a[href="#"][class="atomic-link"]), text: "Link From Atomic"
      assert_select %(img[src*="image.jpg"][class="atomic-img"])
    end
  end
end