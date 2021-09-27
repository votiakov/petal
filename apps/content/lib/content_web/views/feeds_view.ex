defmodule Legendary.Content.FeedsView do
  use Legendary.Content, :view
  use Phoenix.HTML

  import Legendary.Content.LayoutView, only: [title: 2, excerpt: 2]

  def unauthenticated_post?(post) do
    post.password == nil || String.length(post.password) == 0
  end
end
