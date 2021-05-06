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

Since Legendary is both a template and a framework, you can simply clone the repo
to start using it. It's a fully functional Phoenix app as-is. To start a new project:

```sh
git clone https://gitlab.com/mythic-insight/legendary.git <project_name>
```

In order to start the server, run `script/server`. Any dependencies required
will be installed automatically using [brew](https://brew.sh/),
[asdf](https://asdf-vm.com/#/), and [hex](https://hex.pm/).

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Development

Check out [the tutorial](tutorial.md) to learn how to build your first app with
Legendary.

Your main app lives in apps/app/ and you will do most of your
development there. This is a normal Phoenix application and you can develop it
as such. Any resources which apply to developing Phoenix applications will apply
inside of the app. See the [Phoenix Guides](https://hexdocs.pm/phoenix/overview.html)
for a good starting resource in Phoenix development.

You should not generally need to change code in the other applications which
are part of the framework-- apps/admin, apps/content, apps/core. We encourage you
to avoid changing those as much as possible, because doing so will make it more
difficult to upgrade Legendary to newer versions. However, they are available to
you if you find that there are no other ways to accomplish the changes that you want.
If you find yourself adding functionality to admin, content, or core
that you feel would be beneficial to all Legendary apps, consider making a
code contribution back to the framework!

## CI Configuration

Legendary comes with GitLab CI settings which should work for you with minimal
setup.

The CI script will automatically tag successful builds. To do this, you will
need to configure a [CI variable](https://docs.gitlab.com/ee/ci/variables/) named
`GITLAB_TOKEN`. This token should be a
[personal access token](https://gitlab.com/-/profile/personal_access_tokens) with
`read_repository, write_repository` permissions.

## DevOps

The preconfigured CI pipeline generates semantically versioned docker images that
you can deploy in your choice of dockerized hosting. We also provide a manifest
for Kubernetes that is automatically updated with each version (see infrastructure/
for the generated result and infrastructure_templates/ for the templates used to
generate the manifest).
