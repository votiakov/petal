defmodule CoreWeb.CoreEmailView do
  use Phoenix.View,
    root: "lib/core_web/templates",
    namespace: CoreWeb,
    pattern: "**/*"

  import CoreWeb.EmailHelpers
end
