# End to End Testing

Legendary integrates [Cypress](https://cypress.io) for integration and end-to-end (E2E)
testing. In our opinion, Cypress is the best toolkit available for testing end-to-end
in-browser experiences. It has several features that make writing end-to-end tests as
easy as possible:

- **Rock-solid builds.** In our experience, selenium and chromedriver-based setups
  break frequently on even minor version bumps. Every version of Cypress has worked
  as intended for us.
- **Automatic waiting.** Cypress handles async code without needing to manually
  sprinkle waits and sleeps through your test code. I know your test framework
  _says_ it does auto-waiting. Auto-waiting in Cypress actually works.
- **Debugging.** You can use Chrome DevTools (or the equivalent in your favorite
  browser) to debug your tests.
- **Automatic videos of your test runs.**

## A Word of Advice from Your Pal Robert

Don't over-do it with integration and end-to-end testing. It's tempting to end-to-end
test everything. After all, end-to-end tests _should_ catch any issue in your application,
no matter what layer it happens in: model, view, controller, or even JavaScript.
So what's the problem?

For one, when compared to unit tests, integration and
E2E tests are more labor intensive. It usually takes less time to write several
unit tests covering all the aspects of your feature than it does to write one
end-to-end scenario.

Secondly, integration and e2e tests are good are identifying that you have a problem, but
not where that problem occurs. They cast a broad net. When an e2e test fails, it
does not point to a specific broken function or module. Unit tests do.

Thirdly, E2E tests are slow. They have to wait for your page and
all the related assets to load over a real HTTP connection. This is orders of magnitude
slower than calling some functions.

It's best to stick to the [Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html).
The majority of your tests should be unit tests and the majority of your code
should be tested by unit tests.

![Test Pyramid](assets/testing-pyramid.svg)

## Running E2E Tests

To run your Cypress tests, do:

```
npm run test:integration
```

## Writing E2E Tests

[Read the Cypress guide to Writing Your First Test](https://docs.cypress.io/guides/getting-started/writing-your-first-test) to get started writing e2e tests with Cypress.


### Preparing Your Database

In most cases, you'll
need to prepare your database first. Legendary gives you a tool for doing this
called _seed sets_. Seed sets are Elixir scripts that your Cypress suite can
invoke to make sure the database is in the needed state at the start of a test.

Check the `apps/app/test/seed_sets` directory. Each seed set is just a .exs file
which can be executed with a Cypress command. There's an example `apps/app/test/seed_sets/blog.exs`
which prepares the database with a blog post. It looks like this:

```elixir
alias Legendary.Content.Post
alias Legendary.Content.Repo

%Post{
  title: "Public post",
  name: "public-post",
  status: "publish",
  type: "post",
  date: ~N[2020-01-01T00:00:00],
}
|> Repo.insert!()
```

You can put whatever Elixir code you need in a seed_set!

From your Cypress tests, you can run a seed_set like:

```js
cy.setupDB("app", "blog")
```

This invokes the seed set called blog (i.e. blog.exs) from the Elixir app called
`app` (i.e. your app within the Legendary framework). See
`apps/app/cypress/integration/blog_spec.js` for the complete example.

You can only have one seed set loaded at a time because loading a seed set also
sets your test up with an isolated database connection. This isolation allows
us to automatically clean up the database between each test.

### More Test Writing

Check out the [Cypress docs](https://docs.cypress.io/) for much more information
on writing tests with Cypress.

## CI Setup

We also run the Cypress suite in CI. We save the video of each test as
an artifact so that you can download and view them.
