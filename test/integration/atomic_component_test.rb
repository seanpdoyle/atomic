require "atomic_test_case"

class AtomicComponentTest < AtomicTestCase
  test "atomic.component renders partials within atomic/components" do
    declare_template "comments/show", <<~ERB
      <%= atomic.component.wrapper do %>
        Wrapped Text
      <% end %>
    ERB
    declare_template "atomic/components/_wrapper", <<~ERB
      <div class="wrapper">
        <%= block.call %>
      </div>
    ERB

    render "comments/show"

    assert_select %(div[class="wrapper"]), text: "Wrapped Text", count: 1
  end
end
