defmodule Legendary.Core.Routes do
  defmacro __using__(_opts \\ []) do
    quote do
      scope path: "/admin/feature-flags" do
        pipe_through :require_admin

        forward "/", FunWithFlags.UI.Router, namespace: "admin/feature-flags"
      end
    end
  end
end
