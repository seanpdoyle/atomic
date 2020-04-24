require "atomic_test_case"

class AtomicTest < AtomicTestCase
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

  test "atomic overrides Rails view helpers" do
    declare_template "comments/show", <<~ERB
      <%= atomic.link_to "#" do %>
        Link
      <% end %>
    ERB
    declare_template "atomic/_link_to", <<~ERB
      <%= link_to(*arguments, class: "atomic-link", **options, &block) %>
    ERB

    render "comments/show"

    assert_select %(a[href="#"][class="atomic-link"]), text: "Link", count: 1
  end

  test "view partials declare foundational defaults as options" do
    declare_template "comments/show", <<~ERB
      <%= atomic.link_to(
        "#",
        id: "passed-along",
        rel: nil,
        class: "link--special",
        "data-controller": "special-link",
      ) do %>
        Link
      <% end %>
    ERB
    declare_template "atomic/_link_to", <<~ERB
      <%= link_to(
        *arguments,
        **options.with_token_list_defaults(
          class: "atomic-link",
          "data-controller": "tracked-link",
          "data-action": "click->tracked-link#track",
        ).with_defaults(
          rel: "nofollow",
        ),
        &block
      ) %>
    ERB

    render "comments/show"

    assert_select %(a[rel="nofollow"]), count: 0
    assert_select %(a[href="#"][id="passed-along"]), text: "Link", count: 1
    assert_select %(a[class~="atomic-link"][class~="link--special"]), count: 1
    assert_select %(a[data-controller~="tracked-link"]), count: 1
    assert_select %(a[data-controller~="special-link"]), count: 1
    assert_select %(a[data-action~="click->tracked-link#track"]), count: 1
  end
end
