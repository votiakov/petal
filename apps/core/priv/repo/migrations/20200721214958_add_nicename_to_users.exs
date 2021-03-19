defmodule Legendary.Core.Repo.Migrations.AddNicenameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :display_name, :string, default: nil
    end
  end
end
