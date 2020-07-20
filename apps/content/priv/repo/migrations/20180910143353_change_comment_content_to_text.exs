defmodule Content.Repo.Migrations.ChangeCommentContentToText do
  use Ecto.Migration

  def change do
    alter table("wp_comments") do
      modify :comment_content, :text
    end
  end
end
