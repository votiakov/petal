defmodule Admin.Kaffy.EditorExtension do
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
