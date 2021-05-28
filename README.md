# Overview

Legendary is a boilerplate for developing [PETAL-stack](https://changelog.com/posts/petal-the-end-to-end-web-stack)
Phoenix/Elixir applications without reinventing the wheel. Out-of-the-box, we
include many features that are commonly needed in web applications:

- Features
  - Authentication & Authorization
  - Admin interface & dashboard
  - Lightweight content management / blogging
  - Background & scheduled jobs with Oban
- Frontend Frameworks
  - Tailwind CSS
  - Alpine JS
  - Fluid HTML email templates
- Full CI / DevOps scripts included

We got tired of setting these things up from scratch on every Phoenix application.
So, we built a boilerplate that lets you start with the unique & interesting thing
that only your application does. We have a roadmap for future feature development
because we still think there are a lot more things we can do to make Phoenix
development better.

## Up and Running

In order to start the server, run `script/server`. Any dependencies required
will be installed automatically using [brew](https://brew.sh/),
[asdf](https://asdf-vm.com/#/), and [hex](https://hex.pm/).

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Application Development

Your main app lives in apps/app/ and that is where you will do most of your
development there. This is a normal Phoenix application and you can develop it
as such. Any resources which apply to developing Phoenix applications will apply
inside of the app. See the [Phoenix Guides](https://hexdocs.pm/phoenix/overview.html)
for a good starting resource in Phoenix development.

You should not generally need to change code in the other applications which
are part of the framework-- admin, content, core. We encourage you to avoid
changing those as much as possible, because doing so will make it more difficult
to upgrade Legendary to newer versions. However, they are available to you if
you find that there are no other ways to accomplish the changes you want to
accomplish. If you find yourself adding functionality to admin, content, or core
that you feel would be beneficial to all Legendary apps, consider making a
code contribution back to the framework!

## CI Configuration

Legendary comes with gitlab CI settings which should work for you with minimal
setup.

The CI script will automatically tag successful builds. To do this, you will
need to configure a [CI variable](-/settings/ci_cd) named `GITLAB_TOKEN`. This
token should be a [personal access token](/-/profile/personal_access_tokens) with
`read_repository, write_repository` permissions.


# Support

Want to support development? Chip in on buymeacoffee:

<a href="https://www.buymeacoffee.com/prehnra" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" >
</a>
