defmodule Legendary.Content.MarkupField do
  @moduledoc """
  Custom field type definition for markdown fields. Currently uses simplemde
  to provide a markdown editing GUI.
  """
  use Ecto.Type
  def type, do: :string

  import Phoenix.HTML, only: [sigil_E: 2]
  import Phoenix.HTML.Form, only: [textarea: 3, label: 2]

  def cast(text) when is_binary(text) do
    {:ok, text}
  end

  def cast(_), do: :error

  def load(data) do
    {:ok, data}
  end

  def dump(text) when is_binary(text), do: {:ok, text}
  def dump(_), do: :error

  def render_form(_conn, _changeset, form, field, admin_opts) do
    rows = Map.get(admin_opts, :rows, 32)

    ~E"""
    <div class="form-group ">
      <%= label(form, field) %>
      <%= textarea(form, field, [class: "form-control", rows: rows, "data-simplemde": true]) %>
    </div>
    """
  end

  def render_index(_conn, resource, field, _opts) do
    case Map.get(resource, field) do
      nil ->
        ""
      text ->
        Legendary.Content.PostsView.process_content(text)
    end
  end
end
