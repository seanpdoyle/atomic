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

    test "makes options available to the template" do
      declare_template "users/show", <<~ERB
        <%= atomic.link_to "#", class: "from-template" do %>
          Link From Atomic
        <% end %>
      ERB
      declare_template "atomic/_link_to", <<~'ERB'
        <%= link_to(*arguments, class: "from-partial #{options.delete(:class)}", **options, &block) %>
      ERB

      render "users/show"

      assert_select %(a[class="from-partial from-template"]), text: "Link From Atomic"
    end

    test "has existing partials available for use" do
      declare_template "users/show", <<~ERB
      <%= atomic.image_tag "image.jpg" %>
      ERB
      declare_template "atomic/_image_tag", <<~'ERB'
        <% src, * = *arguments %>

        <%= atomic_tag.img(src: image_path(src), **options, &block) %>
      ERB
      declare_template "atomic/_img", <<~'ERB'
        <%= tag.img(*arguments, class: "image", **options, &block) %>
      ERB

      render "users/show"

      assert_select %(img[src*="image.jpg"][class="image"])
    end

    test "translates text with the calling template's scope" do
      with_translations posts: { show: { title: "Title From Atomic" } } do
        declare_template "posts/show", <<~ERB
          <%= atomic.link_to "#" do %>
            <%= translate(".title") %>
          <% end %>
        ERB
        declare_template "atomic/_link_to", <<~'ERB'
          <%= link_to(*arguments, class: "link", **options, &block) %>
        ERB

        render "posts/show"

        assert_select %(a[href="#"][class="link"]), text: translate("posts.show.title")
      end
    end

    test "translates text when the partial uses the `yield` keyword" do
      with_translations posts: { show: { link: "Translated" } } do
        declare_template "posts/show", <<~ERB
          <%= atomic.link_to "#" do %>
            <%= translate(".link") %>
          <% end %>
        ERB
        declare_template "atomic/_link_to", <<~ERB
          <%= link_to(*arguments, class: "atomic-link", **options) do %>
            <%= yield %>
          <% end %>
        ERB

        render "posts/show"

        assert_select %(a[href="#"][class="atomic-link"]), text: "Translated"
      end
    end
  end
end
