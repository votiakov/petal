use Mix.Config

config :kaffy,
  otp_app: :admin,
  ecto_repo: Admin.Repo,
  router: Admin.Router,
  resources: &Admin.Kaffy.Config.create_resources/1

config :admin, Admin,
  resources: [
    auth: [
      name: "Auth",
      resources: [
        user: [schema: Auth.User, admin: Auth.UserAdmin],
      ]
    ],
    content: [
      name: "Content",
      resources: [
        post: [schema: Content.Post, admin: Content.PostAdmin, label: "Posts and Pages"]
      ]
    ]
  ]
