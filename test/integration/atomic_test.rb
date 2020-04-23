require "atomic_test_case"

class AtomicTest < AtomicTestCase
  test "atomic_tag falls back to Rails defaults when a template is not specified" do
    declare_template "users/show", <<~ERB
      <%= atomic_tag.h1 do %>
        Title From Atomic
      <% end %>
    ERB

    render "users/show"

    assert_select %(h1), text: "Title From Atomic"
  end

  test "atomic_tag renders a template when available" do
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
