use Mix.Config

config :kaffy,
  otp_app: :admin,
  ecto_repo: Legendary.Admin.Repo,
  extensions: [
    Legendary.Admin.Kaffy.EditorExtension,
  ],
  router: Legendary.Admin.Router,
  resources: &Legendary.Admin.Kaffy.Config.create_resources/1

config :admin, Legendary.Admin,
  resources: [
    auth: [
      name: "Auth",
      resources: [
        user: [schema: Legendary.Auth.User, admin: Legendary.Auth.UserAdmin],
      ]
    ],
    content: [
      name: "Content",
      resources: [
        post: [schema: Legendary.Content.Post, admin: Legendary.Content.PostAdmin, label: "Posts and Pages", id_column: :name],
        comment: [schema: Legendary.Content.Comment, admin: Legendary.Content.CommentAdmin],
      ]
    ]
  ]
