defmodule Legendary.Admin.Kaffy.EditorExtension do
  @moduledoc """
  Bring in additional CSS and JS for the admin interface e.g. the
  markdown editor library.
  """

  def stylesheets(_conn) do
    [
      {:safe, ~s(<link rel="stylesheet" href="/css/content-editor.css" />)},
      {:safe, ~s(<link rel="stylesheet" href="/css/app.css" />)},
    ]
  end

  def javascripts(_conn) do
    [
      {:safe, ~s(<script src="/js/content-editor.js"></script>)},
      {:safe, ~s(<script src="/js/app.js"></script>)},
    ]
  end
end
