# Atomic

Use `ActionView` partials for your application's components

## Usage

### View partials for Rails-provided helper methods

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

### View Partials for your application's components

The `atomic.component` view helper provides a means of rendering view partials
declared in `app/views/atomic/components`.

For example, consider a `comments/show` template:

```html+erb
<%# app/views/comments/show.html.erb %>

<div class="card">
  <div class="card__contents">
    <p class="comment">
      View components can be powerful!
    </p>
  </div>

  <footer class="card__footer">
    <div class="avatar">
      <img class="avatar__image" src="images/avatar-123.jpg" alt="Author Name's avatar">

      <span class="avatar__name">Author Name</span>
    </div>
  </footer>
</div>
```

There are at least three component-level concepts at-play in this template:
`card`, `comment`, and `avatar`. Let's replace them with calls to `atomic.component`:

```html+erb
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
```

Let's declare view partials for each of those components.

First, let's consider the `avatar` component. It accepts view-local variables,
and _does not_ accept a block:

```html+erb
<%# app/views/atomic/components/_avatar.html.erb %>
<div class="avatar">
  <img class="avatar__image" src="<%= src %>" alt="<%= name %>'s avatar">

  <span class="avatar__name"><%= name %></span>
</div>
```

Next, let's consider the `comment` component. It accepts a singular block for,
which it yields as the content of the comment:

```html+erb
<%# app/views/atomic/components/_comment.html.erb %>
<div class="comment">
  <%= yield %>
</div>
```

Finally, let's consider the `card` component. It accepts a block that it yields
_multiple_ times. It yields it once for the `:contents` section, and once for
the `:footer` section. When rendering the component from the calling view
template, it's crucial to accept the `section` as the second block parameter,
and use that value to determine which `yield` is being executed.

Within the view partial, calls to `yield` will ensure the correct value for
`section` is passed to the caller's block:

```html+erb
<%# app/views/atomic/components/_card.html.erb %>
<div class="card">
  <div class="card__contents">
    <%= yield nil, :contents %>
  </div>

  <footer class="card__footer">
    <%= yield nil, :footer %>
  </footer>
</div>
```

While a `case` statement full of `when` clauses in your view might be surprising
and awkward at times, it's a pattern that the [`ActionView::PartialRenderer`
guides suggest][PartialRenderer].

[PartialRenderer]: https://api.rubyonrails.org/v6.0/classes/ActionView/PartialRenderer.html#class-ActionView::PartialRenderer-label-Rendering+partials+with+layouts

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
