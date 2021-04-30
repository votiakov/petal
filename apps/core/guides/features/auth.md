# Authentication and Authorization

Legendary provides a set of authentication and authorization features out of the
box.

# Authentication

Legendary comes with authentication powered by [Pow](https://powauth.com/) out
of the box. The default configuration:

- supports sign in and registration with an email and password
- allows password resets
- requires users to confirm their email address before logging in
- emails for email confirmation and password reset will be nicely styled using your app's
email styles

> Tip: in development mode, emails your app sends will be visible at http://localhost:4000/sent_emails.

Your Pow configuration can be customized in config/config.exs.

By default, users can be administrated in the admin interface.

# Roles and Authorization

Users have an array of roles. By default, a user has no roles, but they can have
as many as you need. Roles in Legendary are arbitrary strings that you tag a user
with to give them certain privileges.

For example, here's a typical admin user created by the `mix legendary.create_admin` command:

```elixir
%Legendary.Auth.User{
  email: "legendary@example.com",
  homepage_url: nil,
  id: 1,
  inserted_at: ~N[2021-02-25 22:14:40],
  # This user has one role-- admin!
  roles: ["admin"],
  updated_at: ~N[2021-02-25 22:14:40]
}
```

`admin` happens to be a role that the framework cares about-- via the `mix legendary.create_admin` command and the `:require_admin` pipeline that protects
the admin interface. However, you can use any string you want as a role and check
for it in your code. For example, your app might give some users a `paid_customer`
role and use it to protect certain features. You don't have to declare that in advance with the framework.

In some cases, you may want "resourceful roles"-- a role that corresponds to a
specific resource record in your app. We suggest the following convention for those
role names: `:role_name/:resource_type/:id`. So that could be `owner/home/3` to
indicate the user is the owner of the Home with the id of 3. An authorized guest
to the same home might be `guest/home/3`.

You can check whether a user has a role by calling Legendary.Auth.Roles.has_role?/2:

```elixir
Legendary.Auth.Roles.has_role?(user, "admin")
```

And you can always access the `user.roles` field directly.

# Protected routes

## Signed-In Only Routes

You can require that a given route requires a user by piping through the `:require_auth` pipeline. See apps/app/lib/app_web/router.ex for examples.

## Admin Only Routes

You can lock down a route to the app to only admin users by using the `:require_admin` pipeline. For example, the /admin area of your app is protected
that way. See apps/app/lib/app_web/router.ex for examples.
