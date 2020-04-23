require "atomic_test_case"

class AtomicComponentTest < AtomicTestCase
  class Comment
    include ActiveModel::Model
  end

  test "accepts block with named yields" do
    declare_template "atomic_component_test/comments/_comment", <<~ERB
      <div class="card">
        <header class="card__author">
          <%= yield comment, :author %>
        </header>

        <p class="card__body">
          <%= yield comment, :body %>
        </p>
      </div>
    ERB
    declare_template "comments/show", <<~ERB
      <%= render layout: comment do |comment, section| %>
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
