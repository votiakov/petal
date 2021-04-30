# Email

# Fluid Email Templates

We provide an email template based on
[Cerberus's Fluid Template](https://tedgoas.github.io/Cerberus/#fluid). This
is a template well-suited for transactional email that has been well-tested on
a wide variety of email clients. It should let you send nice looking email from
your app without having to think about it a lot.

# Branding / Theming

Of course, you might want to customize the style of your emails to match your app's
unique look or brand. The trick is that for emails to really work across a broad
set of common clients, they need to _inline their CSS_. We take care of this for
you.

You can customize the variables (colors, sizes, etc) in config/email_styles.exs
and we'll apply them to your emails.

# Mailer

Of course, you may want to send your own emails. We provide two modules to help:

- Legendary.CoreEmail: responsible for generating emails to your specifications
- Legendary.CoreMailer: responsible for sending emails per your configuration

Both are powered by [Bamboo](https://github.com/thoughtbot/bamboo) so you
can follow the Bamboo documentation to learn more about customizing and using
email in your app.

Here's an example:

```elixir
defmodule App.HelloEmail do
  import Bamboo.Email
  use Bamboo.Phoenix, view: AppWeb.EmailView

  def send_hello_email(to) do
    to_address
    |> hello_email()
    |> Legendary.CoreMailer.deliver_later()
  end

  def hello_email(to_address) do
    Legendary.CoreEmail.base_email()
    |> to(to_address)
    |> render(:hello, to_address: to_address)
  end
end
```

> Tip: in development mode, any email you send can be viewed at localhost:4000/sent_emails.

# Email Helpers

Fluid email templates don't do any good if the content of your HTML emails isn't also as fluid and well-tested. We provide email tag helpers so that you don't
have to hand-craft email-friendly HTML. See `Legendary.CoreWeb.EmailHelpers`.

For example, your hello.html.eex might look something like this:

```eex
<%= preview do %>
  Have you heard of our awesome app?
<% end %>

<%= h1 do %>
  Hello, <%= to_address %>
<% end %>
<%= p do %>
  We hope you'll join us.
<% end %>

<%= styled_button href: "http://example.com/" do %>
  Join us!
<% end %>
```

We'll handle generating all of the nested tags and inline CSS needed to make the
email look good.
