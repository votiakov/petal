defmodule Legendary.Admin.Routes do
  @moduledoc """
  Routes from the admin app. Use like:

      use Legendary.Admin.Routes
  """
  defmacro __using__(_opts \\ []) do
    quote do
      use Kaffy.Routes, scope: "/admin", pipe_through: [:require_admin]
    end
  end
end
