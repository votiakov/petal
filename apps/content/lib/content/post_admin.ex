defmodule Content.PostAdmin do
  import Ecto.Query, only: [from: 2]

  def singular_name(_) do
    "Post or Page"
  end

  def plural_name(_) do
    "Posts and Pages"
  end

  def create_changeset(schema, attrs) do
    Content.Post.changeset(schema, attrs)
  end

  def update_changeset(schema, attrs) do
    Content.Post.changeset(schema, attrs)
  end

  def index(_) do
    [
      id: nil,
      post_type: nil,
      post_name: nil,
      post_title: nil,
      post_status: nil,
      post_date_gmt: nil,
      post_modified_gmt: nil,
    ]
  end

  def form_fields(_) do
    authors_query =
      from u in Auth.User,
        where: "admin" in u.roles,
        select: [u.email, u.id]

    authors =
      authors_query
      |> Content.Repo.all()
      |> Enum.map(fn [email, id] ->
        {email, id}
      end)

    [
      post_type: %{choices: [{"Blog Post", :post}, {"Page", :page}]},
      post_name: %{label: "Slug"},
      post_title: nil,
      post_content: %{type: :textarea, rows: 32},
      post_status: %{choices: [{"Publish", :publish}, {"Draft", :draft}]},
      post_author: %{choices: authors},
      post_excerpt: %{type: :textarea, rows: 4},
      sticky: nil,
      comment_status: %{choices: [{"open", :open}, {"closed", :closed}]},
      ping_status: %{choices: [{"open", :open}, {"closed", :closed}]},
      post_password: nil,
      menu_order: nil,
    ]
  end
end
