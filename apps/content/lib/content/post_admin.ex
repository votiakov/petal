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
      type: nil,
      name: nil,
      title: nil,
      status: nil,
      date_gmt: nil,
      modified_gmt: nil,
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
      type: %{choices: [{"Blog Post", :post}, {"Page", :page}]},
      name: %{label: "Slug"},
      title: nil,
      content: %{type: :textarea, rows: 32},
      status: %{choices: [{"Publish", :publish}, {"Draft", :draft}]},
      author_id: %{choices: authors},
      excerpt: %{type: :textarea, rows: 4},
      sticky: nil,
      comment_status: %{choices: [{"open", :open}, {"closed", :closed}]},
      ping_status: %{choices: [{"open", :open}, {"closed", :closed}]},
      menu_order: nil,
    ]
  end
end
