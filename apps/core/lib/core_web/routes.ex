defmodule Legendary.Core.Routes do
  @moduledoc """
  Router module that brings in core framework routes, such as the feature flag
  admin interface. Can be included like:

      use Legendary.Core.Routes
  """
  defmacro __using__(_opts \\ []) do
    quote do
      scope path: "/admin/feature-flags" do
        pipe_through :require_admin

        forward "/", FunWithFlags.UI.Router, namespace: "admin/feature-flags"
      end
    end
  end
end
