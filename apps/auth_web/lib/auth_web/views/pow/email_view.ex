defmodule AuthWeb.EmailView do
  use Phoenix.View,
    root: "lib/auth_web/templates",
    namespace: AuthWeb,
    pattern: "**/*"

  import Phoenix.HTML, only: [raw: 1]
  import CoreWeb.EmailHelpers
end
