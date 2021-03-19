defmodule Legendary.Content.Repo do
  use Ecto.Repo,
    otp_app: :content,
    adapter: Ecto.Adapters.Postgres
end
