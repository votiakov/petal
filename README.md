# Legendary

# Up and Running

In order to start the server, run `script/server`. Any dependencies required
will be installed automatically using [brew](https://brew.sh/),
[asdf](https://asdf-vm.com/#/), and [hex](https://hex.pm/).

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# CI Configuration

Legendary comes with gitlab CI settings which should work for you with minimal
setup.

The CI script will automatically tag successful builds. To do this, you will
need to configure a [CI variable](-/settings/ci_cd) named `GITLAB_TOKEN`. This
token should be a [personal access token](/-/profile/personal_access_tokens) with
`read_repository, write_repository` permissions.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

# Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
