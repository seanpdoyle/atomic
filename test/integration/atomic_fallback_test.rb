require "atomic_test_case"

class AtomicFallbackTest < AtomicTestCase
  test "view partials can fallback to the default behavior" do
    declare_template "comments/show", <<~ERB
      <%= atomic_tag.a(href: "#") do %>
        Link
      <% end %>
    ERB
    declare_template "atomic/tags/_a", <<~ERB
      <%= fallback %>
    ERB

    render "comments/show"

    assert_select %(a[href="#"]), text: "Link", count: 1
  end

  test "view partials can fallback with overridden token lists" do
    declare_template "comments/show", <<~ERB
      <%= atomic_tag.a(href: "#") do %>
        Link
      <% end %>
      <%= atomic.image_tag("image.jpg") %>
    ERB
    declare_template "atomic/tags/_a", <<~ERB
      <%= fallback.with_token_list_defaults(class: "link") %>
    ERB
    declare_template "atomic/_image_tag", <<~ERB
      <%= fallback.with_token_list_defaults(class: "image") %>
    ERB

    render "comments/show"

    assert_select %(a[href="#"][class="link"]), text: "Link", count: 1
    assert_select %(img[src*="image.jpg"][class="image"]), count: 1
  end

  test "view partials can fallback with overriddable defaults" do
    declare_template "comments/show", <<~ERB
      <%= atomic_tag.a(href: "#", class: "special-link") do %>
        Link
      <% end %>
    ERB
    declare_template "atomic/tags/_a", <<~ERB
      <%= fallback.with_defaults(class: "link") %>
    ERB

    render "comments/show"

    assert_select %(a[class="link"]), count: 0
    assert_select %(a[href="#"][class="special-link"]), text: "Link", count: 1
  end
end
