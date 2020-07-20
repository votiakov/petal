defmodule Content.Repo.Migrations.AddMetaValueToWpCommentmetas do
  use Ecto.Migration

  def change do
    alter table("wp_commentmeta") do
      add :meta_value, :string
    end
  end
end
