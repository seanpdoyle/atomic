# Atomic

Use `ActionView` partials for your application's components

## Usage

Use the `atomic_tag` and `atomic` helper methods to access your design system.

The `atomic_tag` interface inherits from [Rails' `#tag` view helper][tag], and
the `atomic` interface serves as an entry point into your application-local
overrides of [`ActionView::Helpers`][helpers].

First, declare the template:

```html+erb
<%# app/views/comments/show.html.erb %>
<div class="comment">
  <%= atomic_tag.h1, class: "comment__title" do %>
    A comment on the topic
  <% end %>

  <aside class="comment__author">
    <%= atomic_tag.h2 do %>
      The author's name
    <% end %>

    <%= atomic.link_to user_comments_path("1")) do %>
      Read their other comments
    <% end %>
  </aside>

  <%= atomic_tag.p, class: "comment__text" do %>
    This is the comment's body text.
  <% end %>
</div>
```

Regardless of which view partials your application declares, `atomic` and
`atomic_tag` will always fall back to the Rails provided defaults.

Go ahead, try this template out; you'll render HTML built atop Rails'-provided
`tag.h1`, `tag.h2`, and `link_to` helpers.

Next, declare view partials for methods you'd like to override:

```html+erb
<%# app/views/atomic/tag/_h1.html.erb %>
<%= tag.h1(*arguments, class: "heading heading--h1", **options, &block) %>

<%# app/views/atomic/tag/_h2.html.erb %>
<%= tag.h2(*arguments, class: "heading heading--h2", **options, &block) %>

<%# app/views/atomic/tag/_p.html.erb %>
<%= tag.h2(*arguments, class: "body-text", **options, &block) %>

<%# app/views/atomic/_link_to.html.erb %>
<%= link_to(*arguments, class: "link", **options, &block) %>
```

[tag]: https://api.rubyonrails.org/classes/ActionView/Helpers/TagHelper.html#method-i-tag
[helpers]: https://api.rubyonrails.org/classes/ActionView/Helpers.html

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'atomic'
```

And then execute:
```bash
$ bundle
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
