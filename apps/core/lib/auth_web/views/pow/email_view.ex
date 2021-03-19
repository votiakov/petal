defmodule Legendary.AuthWeb.EmailView do
  use Phoenix.View,
    root: "lib/auth_web/templates",
    namespace: Legendary.AuthWeb,
    pattern: "**/*"

  import Phoenix.HTML, only: [raw: 1]
end
