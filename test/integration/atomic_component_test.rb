require "atomic_test_case"

class AtomicComponentTest < AtomicTestCase
  test "accepts block with named yields" do
    declare_template "atomic/components/_card", <<~ERB
      <div class="card">
        <header class="card__author">
          <%= yield nil, :author %>
        </header>

        <p class="card__body">
          <%= yield nil, :body %>
        </p>
      </div>
    ERB
    declare_template "comments/show", <<~ERB
      <%= atomic.component.card do |_, section| %>
        <%- case section when :body -%>
          Comment Body
        <%- when :author -%>
          Author Name
        <%- end -%>
      <% end %>
    ERB

    render "comments/show"

    assert_select %(div[class="card"] p[class="card__body"]), text: "Comment Body"
    assert_select %(div[class="card"] header[class="card__author"]), text: "Author Name"
  end

  test "translates named yields with correct scope" do
    with_translations comments: { show: { body: "Comment Body" } } do
      declare_template "atomic/components/_card", <<~ERB
        <div class="card">
          <%= yield nil, :body %>
        </div>
      ERB
      declare_template "comments/show", <<~ERB
        <%= atomic.component.card do |_, section| %>
          <%- case section when :body -%>
            <%= translate(".body") %>
          <%- end -%>
        <% end %>
      ERB

      render "comments/show"

      assert_select %(div[class="card"]), text: "Comment Body"
    end
  end
end
