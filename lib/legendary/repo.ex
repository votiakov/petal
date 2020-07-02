defmodule Legendary.Repo do
  use Ecto.Repo,
    otp_app: :legendary,
    adapter: Ecto.Adapters.Postgres
end
