require "atomic_test_case"

class AtomicComponentTest < AtomicTestCase
  class Comment
    include ActiveModel::Model
  end

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
      <%= render layout: "atomic/components/card" do |_, section| %>
        <%- case section when :body -%>
          Comment Body
        <%- when :author -%>
          Author Name
        <%- end -%>
      <% end %>
    ERB

    render template: "comments/show", locals: { comment: Comment.new }

    assert_select %(div[class="card"] p[class="card__body"]), text: "Comment Body"
    assert_select %(div[class="card"] header[class="card__author"]), text: "Author Name"
  end
end
