defmodule CoreWeb.Helpers do
  @moduledoc """
  HTML helpers for our styled (Fomantic UI) forms.
  """
  use Phoenix.HTML

  import Phoenix.Controller, only: [get_flash: 2]
  import CoreWeb.ErrorHelpers

  def changeset_error_block(changeset) do
    ~E"""
    <%= if changeset.action do %>
      <div class="ui negative message">
        <p>Oops, something went wrong! Please check the errors below.</p>
      </div>
    <% end %>
    """
  end

  def flash_block(conn) do
    ~E"""
    <%= [info: "info", error: "negative"] |> Enum.map(fn {level, class} ->  %>
      <%= if get_flash(conn, level) do %>
        <p class="ui message <%= class %>" role="alert"><%= get_flash(conn, level) %></p>
      <% end %>
    <% end) %>
    """
  end

  def styled_input(f, field, opts \\ []) do
    styled_input(f, field, opts) do
      ""
    end
  end

  def styled_input(f, field, opts, do: content) do
    {icon, rest_opts} = Keyword.pop(opts, :icon, "")
    {classes, rest_opts} = Keyword.pop(rest_opts, :class, "")
    {label_text, rest_opts} = Keyword.pop(rest_opts, :label)
    ~E"""
    <div class="field <%= error_class(f, field) %>">
      <%= if label_text do %>
        <%= label f, field, label_text %>
      <% else %>
        <%= label f, field %>
      <% end %>

      <div class="ui left icon <%= classes %> input">
        <i class="<%= icon %> icon"></i>
        <%= text_input f, field, rest_opts %>
        <%= content %>
      </div>
      <%= error_tag f, field, class: "ui pointing red basic label" %>
    </div>
    """
  end

  def pow_extension_enabled?(extension) do
    {extensions, _rest} = Application.get_env(:auth_web, :pow) |> Keyword.pop(:extensions, [])

    Enum.any?(extensions, & &1 == PowResetPassword)
  end
end
