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

    assert_select %(div[class="card"]) do
      assert_select %(p[class="card__body"]), text: "Comment Body", count: 1
      assert_select %(header[class="card__author"]), text: "Author Name", count: 1
    end
  end

  test "translates named yields with correct scope" do
    with_translations(
      comments: { show: { body: "Comment Body" } },
      atomic: { components: { card: { aside: "From the Partial" } } },
    ) do
      declare_template "atomic/components/_card", <<~ERB
        <div class="card">
          <%= yield nil, :body %>
        </div>
        <aside><%= translate(".aside") %></aside>
      ERB
      declare_template "comments/show", <<~ERB
        <%= atomic.component.card do |_, section| %>
          <%- case section when :body -%>
            <%= translate(".body") %>
          <%- end -%>
        <% end %>
      ERB

      render "comments/show"

      assert_select %(div[class="card"]), text: "Comment Body", count: 1
      assert_select %(aside), text: "From the Partial", count: 1
    end
  end

  test "supports HTML elements inside the block" do
    with_translations comments: { show: { body: "Comment Body" } } do
      declare_template "atomic/components/_card", <<~ERB
        <div class="card">
          <%= yield nil, :body %>
          <%= yield nil, :author %>
        </div>
      ERB
      declare_template "comments/show", <<~ERB
        <%= atomic.component.card do |_, section| %>
          <%- case section when :body -%>
            <span>Comment Body</span>
          <%- when :author -%>
            <%= atomic_tag.h1 do %>
              Author Name
            <% end %>
          <%- end -%>
        <% end %>
      ERB

      render "comments/show"

      assert_select %(div[class="card"]) do
        assert_select %(span), text: "Comment Body", count: 1
        assert_select %(h1), text: "Author Name", count: 1
      end
    end
  end

  test "ensure the example in the README works" do
    declare_template "comments/show", <<~ERB
      <%= atomic.component.card do |_, section| %>
        <% case section when :contents %>
          <%= atomic.component.comment do %>
            View components can be powerful!
          <% end %>
        <% when :footer %>
          <%= atomic.component.avatar(
            name: "Author Name",
            src: image_path("avatar-123.jpg"),
          ) %>
        <% end %>
      <% end %>
    ERB
    declare_template "atomic/components/_avatar", <<~ERB
      <div class="avatar">
        <img class="avatar__image" src="<%= src %>" alt="<%= name %>'s avatar">

        <span class="avatar__name"><%= name %></span>
      </div>
    ERB
    declare_template "atomic/components/_comment", <<~ERB
      <div class="comment">
        <%= yield %>
      </div>
    ERB
    declare_template "atomic/components/_card", <<~ERB
      <div class="card">
        <div class="card__contents">
          <%= yield nil, :contents %>
        </div>

        <footer class="card__footer">
          <%= yield nil, :footer %>
        </footer>
      </div>
    ERB

    render "comments/show"

    assert_select %(div[class="card"]) do
      assert_select %(div[class="card__contents"]) do
        assert_select %(div[class="comment"]), text: "View components can be powerful!", count: 1
      end

      assert_select %(footer[class="card__footer"]) do
        assert_select %(img[src="/images/avatar-123.jpg"][alt="Author Name's avatar"]), count: 1
        assert_select %(span), text: "Author Name", count: 1
      end
    end
  end
end
