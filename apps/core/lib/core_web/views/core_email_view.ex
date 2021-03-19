defmodule Legendary.CoreWeb.CoreEmailView do
  use Phoenix.View,
    root: "lib/core_web/templates",
    namespace: Legendary.CoreWeb,
    pattern: "**/*"

  import Legendary.CoreWeb.EmailHelpers
end
