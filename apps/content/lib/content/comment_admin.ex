defmodule Legendary.Content.CommentAdmin do
  @moduledoc """
  Custom admin logic for blog post comments.
  """

  def index(_) do
    [
      id: nil,
      author: nil,
      author_email: nil,
      author_url: nil,
      content: nil,
      approved: nil,
      date: nil,
      date_gmt: nil,
    ]
  end

  def form_fields(_) do
    [
      author: nil,
      author_email: nil,
      author_url: nil,
      content: %{type: :textarea, rows: 8},
      date: nil,
      date_gmt: nil,
      approved: nil,
    ]
  end
end
