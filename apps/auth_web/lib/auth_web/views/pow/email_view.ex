defmodule AuthWeb.EmailView do
  use Phoenix.View,
    root: "lib/auth_web/templates",
    namespace: AuthWeb,
    pattern: "**/*"

  import CoreWeb.EmailHelpers
  import Phoenix.HTML, only: [raw: 1]
end
