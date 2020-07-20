defmodule Content.Repo.Migrations.AddLinkNotesToWpLinks do
  use Ecto.Migration

  def change do
    alter table("wp_links") do
      add :link_notes, :string
    end
  end
end
