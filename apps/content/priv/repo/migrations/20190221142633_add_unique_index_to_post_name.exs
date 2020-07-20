defmodule Content.Repo.Migrations.AddUniqueIndexToPostName do
  use Ecto.Migration

  def change do
    create unique_index(:wp_posts, ["post_name"])
  end
end
