defmodule Legendary.Core.Repo.Migrations.AddUrlToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :homepage_url, :string, default: nil
    end
  end
end
