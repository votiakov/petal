defmodule Admin.Routes do
  defmacro __using__(_opts \\ []) do
    quote do
      use Kaffy.Routes, scope: "/admin", pipe_through: [:require_admin]
    end
  end
end
