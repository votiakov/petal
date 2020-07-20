defmodule Content.Repo.Migrations.AddDefaultToCommentCount do
  use Ecto.Migration

  def change do
    alter table("wp_posts") do
      modify :comment_count, :integer, default: 0
    end
  end
end
